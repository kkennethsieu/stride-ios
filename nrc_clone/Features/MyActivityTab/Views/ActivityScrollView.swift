//
//  ActivityRootView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import SwiftUI
struct ActivityScrollView: View {
    @Bindable var vm: ActivityViewModel
    var runs: [RunDetails]

    var body: some View {
        if runs.isEmpty {
            NoRunsView()
        } else {
            let stats = vm.summaryStats(runs: runs)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        FilterOptions(selectedFilter: $vm.selectedFilter)

                        VStack {
                            if vm.selectedStat == nil {
                                summaryHeader(stats)
                            } else {
                                if vm.selectedFilter == .all || vm.selectedFilter == .year {
                                    if let stat = vm.selectedStat {
                                        let stats = FilterStatsFormatter.monthStats(runs: runs, anchor: stat.actualDate)
                                        YearlyChartPopup(
                                            date: stat.actualDate,
                                            miles: stats.miles,
                                            time: stats.time,
                                            runs: stats.count
                                        ) { vm.showAllActivity = true }
                                    }
                                } else {
                                    if let stat = vm.selectedStat,
                                       let run = runs.first(where: { Calendar.current.isDate($0.date, inSameDayAs: stat.actualDate) }) {
                                        DailyChartPopup(run: run) { run in vm.selectedRun = run }
                                    } else {
                                        Color.clear
                                    }
                                }
                            }
                        }
                        .frame(height: 160)

                        BarChartSummary(
                            chartData: vm.chartData(runs: runs),
                            filter: vm.selectedFilter,
                            anchor: .now,
                            selectedDate: $vm.chartSelectedDate
                        ) { stat in
                            withAnimation { vm.selectedStat = stat }
                        }
                    }
                    .padding(20)
                    .background(.white)

                    EquatableView(content: RecentActivityList(
                        runs: runs,
                        onSelect: { vm.selectedRun = $0 },
                        onShowAll: { vm.showAllActivity = true }
                    ))
                }
            }
            .onScrollGeometryChange(for: CGFloat.self) { geo in
                geo.contentOffset.y
            } action: { old, new in
                if old != new && (vm.selectedStat != nil || vm.chartSelectedDate != nil) {
                    withAnimation { vm.selectedStat = nil; vm.chartSelectedDate = nil }
                }
            }
        }
    }

    func summaryHeader(_ stats: SummaryStats) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Button { vm.showSelectedFilter = true } label: {
                HStack {
                    Text(FilterStatsFormatter.displayDate(vm.selectedDate, filter: vm.selectedFilter))
                    Image(systemName: "chevron.down")
                }
            }
            .buttonStyle(.plain)
            .disabled(vm.selectedFilter == .all)

            StatItem(label: "Miles", value: RunFormatter.distance(stats.totalDistance), alignment: .leading, size: StatSize.medium)
            statSummary(stats)
        }
    }

    func statSummary(_ stats: SummaryStats) -> some View {
        HStack(spacing: 32) {
            StatItem(label: "Run", value: "\(stats.totalRuns)", alignment: .leading)
            StatItem(label: "Avg. Pace", value: RunFormatter.pace(stats.avgPace), alignment: .leading)
            StatItem(label: "Time", value: RunFormatter.duration(stats.totalDuration), alignment: .leading)
        }
    }
}

#Preview {
    @Previewable @State var vm = ActivityViewModel()
    ActivityScrollView(vm: vm, runs: [])
        .withAppEnvironment()
}
