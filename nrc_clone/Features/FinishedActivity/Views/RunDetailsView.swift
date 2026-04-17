//
//  RunDetailsView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/3/26.
//

import SwiftUI
import MapKit

struct RunDetailsView: View {
    var runDetails: RunDetails 
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack (alignment: .leading, spacing:32){
                header
                
                statsList
                
                splitsList
            }
            .frame(maxWidth:.infinity, alignment: .leading)
        }
        .padding(20)
    }
    
    var header: some View {
        VStack (alignment: .leading, spacing: 8){
            Text(RunFormatter.date(runDetails.date))
                .font(.title2)
                .fontWeight(.semibold)
            Text(RunFormatter.timeRange(start: runDetails.startTime ?? .now , end: runDetails.endTime ?? .now))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    var statsList: some View {
        VStack(alignment:.leading, spacing: 18){
            statRow(label: "Distance", value: "\(RunFormatter.distance(runDetails.distance)) mi")
            Divider()
            statRow(label: "Avg. Pace", value: RunFormatter.pace(runDetails.avgPace))
            Divider()
            statRow(label: "Fastest Pace", value: RunFormatter.pace(runDetails.fastestPace ?? 0.0))
            Divider()
            statRow(label: "Running Time", value: RunFormatter.duration(runDetails.activeTime))
            Divider()
            statRow(label: "Elapsed Time", value: RunFormatter.duration(runDetails.elapsedTime ?? 0.0))
            Divider()
            statRow(label: "Elevation Gain", value: RunFormatter.elevation(runDetails.elevationGain ?? 0.0))
            Divider()
            statRow(label: "Elevation Loss", value: RunFormatter.elevation(runDetails.elevationLoss ?? 0.0))
            Divider()
            statRow(label: "Avg. Heart Rate", value: RunFormatter.heartRate(runDetails.avgHR ?? 0.0))
            Divider()
            statRow(label: "Max Heart Rate", value: RunFormatter.heartRate(runDetails.maxHR ?? 0.0))
        }
    }
    
    func statRow(label: String, value: String) -> some View {
        HStack{
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
    
    var splitsList: some View {
        VStack(alignment:.leading, spacing: 22){
            Text("Splits")
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack {
                Text("Mile").frame(maxWidth: .infinity, alignment: .leading)
                Text("Avg. Pace").frame(maxWidth: .infinity, alignment: .leading)
                Text("+/-").frame(maxWidth: .infinity, alignment: .center)
                Image(systemName: "mountain.2").frame(maxWidth: .infinity, alignment: .trailing)
            }
            .foregroundStyle(.secondary)
            .font(.caption)
            
            if let splits = runDetails.splits, !splits.isEmpty {
                ForEach(Array(splits.enumerated()), id: \.element.id) { index, split in
                    let diff = split.avgPace - runDetails.avgPace  // seconds per meter
                    
                    splitRow(
                        distance: split.distance < 1609 ? RunFormatter.distance(split.distance) : "\(index + 1)",
                        avgPace: RunFormatter.pace(split.avgPace),
                        paceDiff: RunFormatter.paceDiff(diff),
                        elevation: RunFormatter.elevation(split.elevation),
                        isFaster: diff < 0
                    )
                }
            }
            
        }
    }
    
    func splitRow(distance: String, avgPace: String, paceDiff: String, elevation: String, isFaster: Bool) -> some View {
        HStack {
            Text(distance)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(avgPace)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(paceDiff)
                .foregroundStyle(isFaster ? .green : .red)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(elevation)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.subheadline)
    }
}

#Preview {
    let fakeRun = RunDetails(
        name: "Morning Run",
        date: Date(),
        splits: [
            Split(distance: 1609.344, duration: 572, avgPace: 572 / 1609.344, elevation: 12.8),
            Split(distance: 1609.344, duration: 615, avgPace: 615 / 1609.344, elevation: 19.8),
            Split(distance: 1609.344, duration: 708, avgPace: 708 / 1609.344, elevation: -6.1),
            Split(distance: 1609.344, duration: 545, avgPace: 545 / 1609.344, elevation: 24.4),
            Split(distance: 1609.344, duration: 750, avgPace: 750 / 1609.344, elevation: -3.0),
            Split(distance: 609.344, duration: 750, avgPace: 750 / 1609.344, elevation: -3.0),
        ],
        distance: 8046.72,       // 5 miles in meters
        activeTime: 3190,        // ~53 mins
        elapsedTime: 3450,       // ~57 mins with pauses
        avgPace: 3190 / 8046.72, // seconds per meter
        fastestPace: 545 / 1609.344,
        elevationGain: 57.2,     // meters
        elevationLoss: 15.2,     // meters
        avgHR: 158,
        maxHR: 181,
        startTime: Date(),
        endTime: Date().addingTimeInterval(3450),
        coordinates:     [
            CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
            CLLocationCoordinate2D(latitude: 32.7162, longitude: -117.1605),
            CLLocationCoordinate2D(latitude: 32.7168, longitude: -117.1598),
            CLLocationCoordinate2D(latitude: 32.7175, longitude: -117.1590),
            CLLocationCoordinate2D(latitude: 32.7181, longitude: -117.1582),
            CLLocationCoordinate2D(latitude: 32.7188, longitude: -117.1575),
            CLLocationCoordinate2D(latitude: 32.7194, longitude: -117.1568),
            CLLocationCoordinate2D(latitude: 32.7200, longitude: -117.1560),
            CLLocationCoordinate2D(latitude: 32.7206, longitude: -117.1553),
            CLLocationCoordinate2D(latitude: 32.7210, longitude: -117.1545),
            CLLocationCoordinate2D(latitude: 32.7208, longitude: -117.1537),
            CLLocationCoordinate2D(latitude: 32.7203, longitude: -117.1530),
            CLLocationCoordinate2D(latitude: 32.7197, longitude: -117.1523),
            CLLocationCoordinate2D(latitude: 32.7191, longitude: -117.1517),
            CLLocationCoordinate2D(latitude: 32.7185, longitude: -117.1510),
            CLLocationCoordinate2D(latitude: 32.7179, longitude: -117.1518),
            CLLocationCoordinate2D(latitude: 32.7173, longitude: -117.1525),
            CLLocationCoordinate2D(latitude: 32.7167, longitude: -117.1533),
            CLLocationCoordinate2D(latitude: 32.7161, longitude: -117.1540),
            CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
        ]
        
    )
    
    RunDetailsView(runDetails: fakeRun)
}
