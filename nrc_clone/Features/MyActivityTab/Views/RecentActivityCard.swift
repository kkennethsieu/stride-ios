//
//  RecentActivityCard.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//

import SwiftUI
import MapKit

struct RecentActivityCard: View {
    var run: RunDetails
    var onSelect: (RunDetails) -> Void
    
    var body: some View {
        Button{ onSelect(run) }
        label:{
            VStack(alignment:.leading, spacing: 22){
                HStack(spacing: 12){
                    ZStack{
                        if !run.coordinates.isEmpty{
                            MapArea(coordinates: run.coordinates, isActive: false)
                        } else {
                            Image("run_image")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .frame(width:52, height:52)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack (alignment: .leading, spacing: 4){
                        Text(RunFormatter.numberDate(run.date))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(run.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                
                HStack(spacing: 40){
                    StatItem(label: "Miles", value: RunFormatter.distance(run.distance), alignment: .leading, size: StatSize.xSmall)
                    StatItem(label: "Avg. Pace", value: RunFormatter.pace(run.avgPace), alignment: .leading, size: StatSize.xSmall)
                    StatItem(label: "Time", value: RunFormatter.duration(run.activeTime), alignment: .leading, size: StatSize.xSmall)
                }
                
            }
            .frame(maxWidth:.infinity, alignment:.leading)
            .padding(18)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RecentActivityCard(
        run: RunDetails(
            name: "Morning Run",
            date: .now,
            distance: 8046.72,
            activeTime: 3190,
            avgPace: 3190 / 8046.72
        ),
        onSelect: { _ in }
    )
    .padding()
}
