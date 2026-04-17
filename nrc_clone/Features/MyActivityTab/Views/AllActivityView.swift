//
//  AllActivityView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//

import SwiftUI

struct AllActivityView: View {
    let runs: [RunDetails]
    var onSelect: (RunDetails) -> Void
    
    var groupedRuns: [(key: String, value: [RunDetails])] {
        let grouped = Dictionary(grouping: runs) { run in
            run.date.formatted(.dateTime.month(.wide).year())
        }
        return grouped.sorted { a, b in
            let dateA = a.value.first?.date ?? Date.distantPast
            let dateB = b.value.first?.date ?? Date.distantPast
            return dateA > dateB
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack{
                ForEach(groupedRuns, id: \.key) { month, runs in
                    VStack(alignment: .leading, spacing: 16) {
                        Text(month)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)
                        VStack{
                            ForEach(runs) { run in
                                RecentActivityCard(run:run){ selectRun in
                                    onSelect(selectRun)
                                }
                            }
                        }
                    }
                }
            }
            .padding(20)
            .navigationTitle("All Activity")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AllActivityView(runs: [
        RunDetails(
            name: "Morning Run",
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            splits: [], distance: 8046.72, activeTime: 3190, elapsedTime: 3450,
            avgPace: 3190 / 8046.72, fastestPace: 545 / 1609.344,
            elevationGain: 57.2, elevationLoss: 15.2, avgHR: 158, maxHR: 181,
            startTime: Date(), endTime: Date().addingTimeInterval(3190), coordinates: []
        ),
        RunDetails(
            name: "Evening Jog",
            date: Calendar.current.date(byAdding: .day, value: -12, to: Date())!,
            splits: [], distance: 4828.03, activeTime: 1680, elapsedTime: 1800,
            avgPace: 1680 / 4828.03, fastestPace: 490 / 1609.344,
            elevationGain: 22.5, elevationLoss: 18.1, avgHR: 148, maxHR: 167,
            startTime: Date(), endTime: Date().addingTimeInterval(1680), coordinates: []
        ),
        RunDetails(
            name: "Long Run",
            date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
            splits: [], distance: 16093.44, activeTime: 6480, elapsedTime: 6900,
            avgPace: 6480 / 16093.44, fastestPace: 520 / 1609.344,
            elevationGain: 112.3, elevationLoss: 98.7, avgHR: 162, maxHR: 185,
            startTime: Date(), endTime: Date().addingTimeInterval(6480), coordinates: []
        ),
        RunDetails(
            name: "Trail Run",
            date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!,
            splits: [], distance: 6437.38, activeTime: 2580, elapsedTime: 2700,
            avgPace: 2580 / 6437.38, fastestPace: 510 / 1609.344,
            elevationGain: 88.4, elevationLoss: 76.2, avgHR: 155, maxHR: 178,
            startTime: Date(), endTime: Date().addingTimeInterval(2580), coordinates: []
        )
    ]){ _ in
        let text = Text("opened all activity")
    }
}
