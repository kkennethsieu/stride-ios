//
//  FilterStatsFormatter.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/7/26.
//

import Foundation

struct FilterStatsFormatter {
    
    static func totalDistance(runs: [RunDetails], filter: FilterOption, anchor: Date = .now) -> Double {
        runs.filter { isInPeriod($0.date, filter: filter, anchor: anchor) }
            .reduce(0) { $0 + $1.distance }
    }

    static func totalRuns(runs: [RunDetails], filter: FilterOption, anchor: Date = .now) -> Int {
        runs.filter { isInPeriod($0.date, filter: filter, anchor: anchor) }.count
    }

    static func avgPace(runs: [RunDetails], filter: FilterOption, anchor: Date = .now) -> Double {
        let filtered = runs.filter { isInPeriod($0.date, filter: filter, anchor: anchor) }
        guard !filtered.isEmpty else { return 0 }
        return filtered.reduce(0) { $0 + $1.avgPace } / Double(filtered.count)
    }

    static func totalDuration(runs: [RunDetails], filter: FilterOption, anchor: Date = .now) -> Double {
        runs.filter { isInPeriod($0.date, filter: filter, anchor: anchor) }
            .reduce(0) { $0 + $1.activeTime }
    }
    
    static func isInPeriod(_ date: Date, filter: FilterOption, anchor: Date = .now) -> Bool {
        let calendar = Calendar.current
        switch filter {
        case .week:
            return calendar.isDate(date, equalTo: anchor, toGranularity: .weekOfYear)
        case .month:
            return calendar.isDate(date, equalTo: anchor, toGranularity: .month)
        case .year:
            return calendar.isDate(date, equalTo: anchor, toGranularity: .year)
        case .all:
            return true
        }
    }
    
    static func displayDate(_ date: Date, filter: FilterOption) -> String {
        let calendar = Calendar.current
        switch filter {
        case .week:
            let start = calendar.dateInterval(of: .weekOfYear, for: date)!.start
            let end = calendar.date(byAdding: .day, value: 6, to: start)!
            return "\(start.formatted(.dateTime.month(.abbreviated).day())) - \(end.formatted(.dateTime.month(.abbreviated).day()))"
        case .month:
            return date.formatted(.dateTime.month(.wide).year())  // "April 2026"
        case .year:
            return date.formatted(.dateTime.year())               // "2026"
        case .all:
            return "All Time"
        }
    }
    
    // for chart
    
    // Makes an array of Runstat from the start of the week with miles depending on the anchor date.
    static func weekData(runs:[RunDetails], anchor: Date) -> [BarRunStat] {
        let days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
        return (0...6).map { offset in
            let start = Calendar.current.dateInterval(of: .weekOfYear, for: anchor)!.start
            let day = Calendar.current.date(byAdding: .day, value: offset, to: start)!
            let miles = runs
                .filter { Calendar.current.isDate($0.date, inSameDayAs: day) }
                .reduce(0) { $0 + $1.distance } / 1609.344
            return BarRunStat(label: days[offset], actualDate: day, miles: miles)
        }
    }
    
    // Makes an array of Runstat from the start of the month with miles depending on the anchor date.
    static func monthData(runs:[RunDetails], anchor: Date) -> [BarRunStat] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: anchor)!
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        return (0..<days).map { offset in
            let day = calendar.date(byAdding: .day, value: offset, to: interval.start)!
            let miles = runs
                .filter { calendar.isDate($0.date, inSameDayAs: day) }
                .reduce(0) { $0 + $1.distance } / 1609.344
            let dayNum = calendar.component(.day, from: day)
            return BarRunStat(label: "\(dayNum)", actualDate: day, miles: miles)
        }
    }
    
    static func yearData(runs:[RunDetails], anchor: Date) -> [BarRunStat] {
        let calendar = Calendar.current
        return (1...12).map { month in
            let miles = runs
                .filter {
                    Calendar.current.isDate($0.date, equalTo: anchor, toGranularity: .year) &&
                    Calendar.current.component(.month, from: $0.date) == month
                }
                .reduce(0) { $0 + $1.distance } / 1609.344
            let firstOfMonth = calendar.date(from: DateComponents(year: calendar.component(.year, from: anchor), month: month, day: 1))!
            return BarRunStat(label: Calendar.current.shortMonthSymbols[month - 1], actualDate:firstOfMonth , miles: miles)
        }
    }
    
    // grabs all the data from the month
    static func monthStats(runs: [RunDetails], anchor: Date) -> (miles: Double, time: Double, count: Int) {
        let filtered = runs.filter {
            Calendar.current.isDate($0.date, equalTo: anchor, toGranularity: .month)
        }
        let miles = filtered.reduce(0) { $0 + $1.distance } / 1609.344
        let time = filtered.reduce(0) { $0 + $1.activeTime }
        return (miles, time, filtered.count)
    }
    
}
