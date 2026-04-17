//
//  BarChartSummary.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//
import SwiftUI
import Charts



struct BarChartSummary: View {
    // MARK: Data shared with me
    let chartData: [BarRunStat]
    let filter: FilterOption
    let anchor: Date
    
    @Binding var selectedDate: String?
    
    var onSelect: (BarRunStat?) -> Void
    
    var selectedStat: BarRunStat? {
        guard let labelDate = selectedDate else { return nil }
        return chartData.first(where: { $0.label == labelDate })
    }
    
    var avgMiles: Double {
        let runsOnly = chartData.filter { $0.miles > 0 }
        guard !runsOnly.isEmpty else { return 0 }
        return runsOnly.reduce(0) { $0 + $1.miles } / Double(runsOnly.count)
    }
    
    var body: some View {
        Chart(chartData) { item in
            BarMark(
                x: .value("Dates", item.label),
                y: .value("Miles", item.miles),
                width: .ratio(0.5)
            )
            .annotation(position: .top) {
                if filter == .week && item.miles > 0 {
                    Text(String(format: "%.1f", item.miles))
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
            }
            .foregroundStyle(item.label == selectedDate ? .black : .blue.opacity(0.5))
            .cornerRadius(6)
            
            avgMileMarker
            
            selectedBar
        }
        .chartXScale(domain: chartData.map(\.label))
        .chartXAxis {
            AxisMarks { value in
                if filter == .month {
                    if let str = value.as(String.self), let day = Int(str), day % 5 == 1 {
                        AxisValueLabel()
                            .font(.caption)
                    }
                } else {
                    AxisValueLabel()
                        .font(.caption)
                }
            }
        }
        .chartYAxis {
            AxisMarks {
                AxisValueLabel()
                    .font(.caption)
                AxisGridLine()
                    .foregroundStyle(.gray.opacity(0.3))
            }
        }
        .chartYScale(domain: 0...max(chartData.map(\.miles).max() ?? 0, 5))
        .chartGesture { proxy in
            SpatialTapGesture()
                .onEnded { value in
                    if let x: String = proxy.value(atX: value.location.x) {
                        let stat = chartData.first(where: { $0.label == x })
                        if let stat, stat.miles > 0 {
                            selectedDate = selectedDate == x ? nil : x
                        } else {
                            selectedDate = nil
                        }
                    }
                }
        }
        .onChange(of: selectedDate){
            onSelect(selectedStat)
        }
        .frame(height: 200)
        .padding(.vertical, 26)
        .padding(.horizontal, 4)
    }
    
    var avgMileMarker: some ChartContent {
        RuleMark(y: .value("Average", avgMiles))
            .annotation(position: .top, alignment: .trailing) {
                Text(String(format: "%.1f", avgMiles))
                    .foregroundStyle(.gray.opacity(0.3))
                    .font(.footnote)
            }
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [6]))
            .foregroundStyle(.gray.opacity(0.4))
    }
    
    @ChartContentBuilder
    var selectedBar: some ChartContent {
        if let selected = selectedStat {
            RuleMark(x: .value("Selected", selected.label), yStart: .value("Start", 0), yEnd: .value("End", (chartData.map(\.miles).max() ?? 5) + 1))
                .foregroundStyle(.black)
        }
    }
}

//#Preview {
//    @Previewable @State var selectedStat: RunStat? = nil
//    @Previewable @State var selectedDate: String? = nil
//    @Previewable @State var selectedFilter: FilterOption = .week
//    @Previewable @State var selectedRun: RunDetails? = nil
//
//    let calendar = Calendar.current
//    let runs: [RunDetails] = (0..<30).map { offset in
//        let date = calendar.date(byAdding: .day, value: -offset, to: .now)!
//        let distance = Double.random(in: 3000...15000)
//        let activeTime = distance * Double.random(in: 0.33...0.42)
//        return RunDetails(
//            name: "Run \(offset)",
//            date: date,
//            distance: distance,
//            activeTime: activeTime,
//            avgPace: activeTime / distance
//        )
//    }
//
//    VStack(spacing: 48) {
//        Group {
//            if selectedFilter == .year || selectedFilter == .all {
//                if let stat = selectedStat {
//                    let stats = FilterStatsFormatter.monthStats(runs: runs, anchor: stat.actualDate)
//                    YearlyChartPopup(
//                        date: stat.actualDate,
//                        miles: stats.miles,
//                        time: stats.time,
//                        runs: stats.count
//                    ) {}
//                } else {
//                    Color.clear
//                }
//            } else {
//                if let stat = selectedStat,
//                   let run = runs.first(where: { Calendar.current.isDate($0.date, inSameDayAs: stat.actualDate) }) {
//                    DailyChartPopup(run: run) { run in
//                        selectedRun = run
//                    }
//                } else {
//                    Color.clear
//                }
//            }
//        }
//        .frame(height: 80)
//
//        BarChartSummary(runs: runs, filter: selectedFilter, anchor: .now, selectedDate: $selectedDate) { stat in
//            selectedStat = stat
//        }
//    }
//    .padding(20)
//}
