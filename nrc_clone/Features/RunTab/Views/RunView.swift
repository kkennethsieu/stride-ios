//
//  RunView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import SwiftUI
import MapKit

struct RunView: View {
    // MARK: Data In
    @Environment(LocationPermissionManager.self) var locationPermission
    // MARK: Data owned by me
    @State private var vm = RunTabViewModel()
    @State private var viewModel = RunViewModel()
    @State private var finishedRun: RunDetails? = nil
    @State private var showPermissionSettings: Bool = false
    
    // MARK: Data shared with me
    @Binding var countdown: Int?
    
    var isRunActive: Binding<Bool> {
        Binding(
            get: { viewModel.runState == .running || viewModel.runState == .paused },
            set: { if !$0 { viewModel.runState = .idle } }
        )
    }
    
    var hasFinishedRun: Binding<Bool> {
        Binding(
            get: { finishedRun != nil },
            set: { if !$0 { finishedRun = nil } }
        )
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                mapOverlay
                
                VStack(alignment:.leading, spacing: 24){
                    runFilters
                    
                    VStack (spacing: 16){
                        scrollCards
                        CardPagination(count: vm.cards.count)
                        
                        Spacer()
                        
                        HStack(spacing:18){
                            CircleActionButton(bgColor: .white, textColor: .black, img:"gear", size:ButtonSize.medium){
                            }
                            CircleActionButton(bgColor: .white, textColor: .black, img:"gear", size:ButtonSize.medium){
                            }
                        }
                        Spacer()
                        HStack(spacing: 18){
                            CircleActionButton(bgColor: .white, textColor: .black, img:"gear", size:ButtonSize.medium){
                            }
                            CircleActionButton(bgColor: .blue.opacity(0.8), textColor: .black, text:"START", size:ButtonSize.large){
                                if locationPermission.authorizationStatus == .notDetermined{
                                    locationPermission.requestPermission()
                                } else if locationPermission.authorizationStatus == .denied {
                                    showPermissionSettings = true
                                } else {
                                    startCountdown()
                                }
                            }
                            
                            CircleActionButton(bgColor: .white, textColor: .black, img:"music.note.slash", size:ButtonSize.medium){
                            }
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding(20)
            }
            .locationPermissionAlert(isPresented: $showPermissionSettings)
            .fullScreenCover(isPresented: isRunActive) {
                ActiveRunView(viewModel: viewModel){ run in
                    finishedRun = run
                }
            }
            .navigationDestination(isPresented: hasFinishedRun){
                if let run = finishedRun{
                    FinishedRunView(runDetails: run)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            .navigationTitle("Run")
        }
        
    }
    
    var runFilters: some View {
        HStack{
            Button{}label:{
                Text("Start a Run")
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
            Button{}label:{
                Text("Guided Runs")
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
        }
    }
    
    var scrollCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(vm.cards){ card in
                    ScrollCardItem(item: card)
                }
            }
            .scrollTargetLayout()
            .safeAreaPadding(.horizontal, 26)
        }
        .frame(height: 100)
        .scrollTargetBehavior(.viewAligned)
    }
    
    var mapOverlay: some View {
        Map(initialPosition: .userLocation(fallback: .automatic))
            .mapStyle(.standard)
            .opacity(0.3)
            .mask {
                RadialGradient(
                    colors: [.black, .clear],
                    center: .center,
                    startRadius: 20,
                    endRadius: 350
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .disabled(true)
    }
    
    func startCountdown() {
        countdown = 3
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            if let current = countdown {
                if current <= 1 {
                    timer.invalidate()
                    countdown = nil
                    viewModel.startRun()
                } else {
                    countdown = current - 1
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var countdown: Int? = nil
    RunView(countdown: $countdown)
        .environment(LocationPermissionManager())
}
