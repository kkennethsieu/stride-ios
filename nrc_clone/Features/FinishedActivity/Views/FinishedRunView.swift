//
//  FinishedRunView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/2/26.
//

import SwiftUI
import SwiftData
import MapKit

struct FinishedRunView: View {
    // MARK: Data In
    @Environment(AuthManager.self) var authManager
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    // MARK: Data owned by me
    @State private var showMoreDetails = false
    @State private var showRouteDetails = false
    @State private var showEditRun = false
    @State private var showDeleteRun = false
    @State private var showingOptions = false
    @State private var snapshot: RunEditSnapshot?
    
    @Bindable var runDetails: RunDetails

    let columns = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack (alignment:.leading, spacing: 18){
                header
                
                StatItem(label: "Miles", value: RunFormatter.distance(runDetails.distance), alignment: .leading ,size: StatSize.medium)
                
                LazyVGrid(columns: columns, alignment:.leading, spacing: 10){
                    runStats
                }
                
                if !runDetails.coordinates.isEmpty{
                    MapArea(coordinates: runDetails.coordinates, isActive: false)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    ClearActionButton(text:"Route Details"){
                        showRouteDetails = true
                    }
                }
                if !(runDetails.splits ?? []).isEmpty{
                    splitsView
                }
                
                TrackShoe()
                
                PostRunMetadata(photoURL:$runDetails.photoURL ,effort: $runDetails.effort, whereIRan: $runDetails.whereIRan, notes: $runDetails.notes)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .onAppear{
            snapshot = RunEditSnapshot(runDetails)
        }
        .onDisappear{
            syncIfNeeded()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .background else { return }
            syncIfNeeded()
        }
        .navigationDestination(isPresented: $showMoreDetails){
            RunDetailsView(runDetails: runDetails)
        }
        .navigationDestination(isPresented: $showRouteDetails){
            MapDetailsView(coordinates: runDetails.coordinates)
        }
        .navigationDestination(isPresented: $showEditRun){
            AddEditRunView(existingRun: runDetails)
        }
        .sheet(isPresented: $showingOptions) {
            MoreOptionsSheet(selectEdit: $showEditRun, selectDelete: $showDeleteRun)
                .presentationDetents([.height(200)])
        }
        .alert("Delete Run?", isPresented: $showDeleteRun){
            Button("Delete", role: .destructive) {
                modelContext.delete(runDetails)
                Task {
                    guard let token = await authManager.getToken() else { return }
                    try? await RunServiceAPI.shared.deleteRun(token: token, id: runDetails.id)
                }
                dismiss()
            }
            Button("Cancel", role: .cancel) {
                showDeleteRun = false
            }
        } message: {
            Text("This cannot be undone")
        }
        .toolbar{
            ToolbarItem(placement: .primaryAction) {
                Button { showingOptions = true } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
    
    var header: some View {
        VStack (alignment: .leading, spacing: 12){
            Text(RunFormatter.dateAndTime(runDetails.date))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack{
                TextField("Name", text: $runDetails.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Button{}label:{
                    Image(systemName: "pencil")
                }
                .buttonStyle(.plain)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.3))
        }
    }
    
    var runStats: some View {
        Group{
            StatItem(label: "Avg Pace", value:  RunFormatter.pace(runDetails.avgPace), alignment: .leading)
            StatItem(label: "miles", value: RunFormatter.distance(runDetails.distance), alignment: .leading)
            StatItem(label: "Time", value: RunFormatter.duration(runDetails.activeTime), alignment: .leading)
            StatItem(label: "Calories", value: "--")
            StatItem(label: "Elevation", value: RunFormatter.elevation(runDetails.elevationGain ?? 0.0), alignment: .leading)
            StatItem(label: "Cadence", value: "134", alignment: .leading)
        }
    }

    var splitsView: some View {
        VStack(alignment: .leading, spacing: 24){
            Text("Splits")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack{
                Text("Mile")
                    .frame(width: 40, alignment: .leading)
                Text("Avg Pace")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("Elevation")
                    .frame(width: 80, alignment: .trailing)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            VStack(spacing: 10) {
                if let splits = runDetails.splits, !splits.isEmpty {
                    ForEach(Array(splits.enumerated()), id: \.element.id) { index, split in
                        SplitRow(split: split, index: index)
                    }
                }
            }
            
            ClearActionButton(text:"More Details"){
                showMoreDetails = true
            }
        }
    }
    
    func syncIfNeeded() {
        guard let snapshot, RunEditSnapshot(runDetails) != snapshot else { return }
        Task {
            if let token = await authManager.getToken() {
                try? await RunServiceAPI.shared.updateRun(token: token, run: runDetails)
            }
        }
    }
    
}

#Preview {
    @Previewable @State var viewModel = RunViewModel()

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
    
    NavigationStack{
        FinishedRunView(runDetails: fakeRun)
            .withAppEnvironment()
    }
}
