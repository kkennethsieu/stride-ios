//
//  ActivityViewModel.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/8/26.
//

import Foundation

struct CacheKey: Hashable {
    let filter: FilterOption
    let date: String
}

@Observable
class ActivityViewModel {
    var selectedFilter: FilterOption = .week
    var showSelectedFilter: Bool = false 
    var selectedDate: Date = .now
    
    var selectedRun: RunDetails? = nil
    var showAllActivity: Bool = false
    var showAddRun: Bool = false
    
    var selectedStat: BarRunStat? = nil
    var chartSelectedDate: String? = nil
    // Settings
    var showSettings: Bool = false
    
    // Summary headers
    var summaryCache: [CacheKey: SummaryStats] = [:]

    // Chart data
    var chartCache: [CacheKey: [BarRunStat]] = [:]
    
    func chartData (runs: [RunDetails]) -> [BarRunStat] {
        let key = cacheKey()
        if let cached = chartCache[key] { return cached }
        let data: [BarRunStat]
        switch selectedFilter {
        case .week:  data = FilterStatsFormatter.weekData(runs: runs, anchor: selectedDate)
        case .month: data = FilterStatsFormatter.monthData(runs: runs, anchor: selectedDate)
        case .year, .all: data = FilterStatsFormatter.yearData(runs: runs, anchor: selectedDate)
        }
        chartCache[key] = data
        return data
    }
    
    func invalidateCache (){
        chartCache = [:]
        summaryCache = [:]
    }
    
    // Summary headers
    func summaryStats(runs: [RunDetails]) -> SummaryStats {
        let key = cacheKey()

        if let cached = summaryCache[key] { return cached }
        let stats = SummaryStats(
            totalDistance: FilterStatsFormatter.totalDistance(runs: runs, filter: selectedFilter, anchor: selectedDate),
            totalRuns: FilterStatsFormatter.totalRuns(runs: runs, filter: selectedFilter, anchor: selectedDate),
            avgPace: FilterStatsFormatter.avgPace(runs: runs, filter: selectedFilter, anchor: selectedDate),
            totalDuration: FilterStatsFormatter.totalDuration(runs: runs, filter: selectedFilter, anchor: selectedDate)
        )
        summaryCache[key] = stats
        return stats
    }
    
    func cacheKey() -> CacheKey {
        let formatted: String
        switch selectedFilter {
        case .week:  formatted = selectedDate.formatted(.dateTime.week().year())
        case .month: formatted = selectedDate.formatted(.dateTime.month().year())
        case .year, .all:  formatted = selectedDate.formatted(.dateTime.year())
        }
        return CacheKey(filter: selectedFilter, date: formatted)
    }
}
