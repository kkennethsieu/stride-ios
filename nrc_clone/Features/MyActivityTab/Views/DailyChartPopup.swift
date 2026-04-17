//
//  ChartPopup.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/7/26.
//

import SwiftUI

struct DailyChartPopup: View {
    var run: RunDetails
    var onSelect: (RunDetails) -> Void
    var body: some View {
        Button{ onSelect(run) }
        label:{
            VStack(alignment: .leading, spacing: 12) {
                HStack{
                    Text(RunFormatter.date(run.date))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                HStack(spacing: 24){
                    MapArea(coordinates: run.coordinates, isActive: false)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    HStack(spacing: 20) {
                        StatItem(label: "Miles", value: RunFormatter.distance(run.distance), alignment: .leading, size: StatSize.xSmall)
                        StatItem(label: "Pace", value: RunFormatter.pace(run.avgPace), alignment: .leading, size: StatSize.xSmall)
                        StatItem(label: "Time", value: RunFormatter.duration(run.activeTime), alignment: .leading, size: StatSize.xSmall)
                    }
                }
            }
            .foregroundStyle(.white)
            .padding(20)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

import MapKit
#Preview {
    let fakeRun = RunDetails(
        name: "Morning Run",
        date: .now,
        distance: 4086,
        activeTime: 2137,
        avgPace: 2137 / 4086,
        coordinates: [
            CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
            CLLocationCoordinate2D(latitude: 32.7162, longitude: -117.1605),
            CLLocationCoordinate2D(latitude: 32.7168, longitude: -117.1598),
            CLLocationCoordinate2D(latitude: 32.7175, longitude: -117.1590),
            CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
        ]
    )
    
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        DailyChartPopup(run: fakeRun){_ in}
            .padding()
    }
}
