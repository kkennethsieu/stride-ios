//
//  ActiveRunView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import SwiftUI
import SwiftData
import MapKit

struct ActiveRunView: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(AuthManager.self) var authManager
    @Environment(NotificationManager.self) var notifyManager

    // MARK: Data owned by me
    @State private var showPause = true
    @State private var holdScale: CGFloat = 1.0
    let columns = [GridItem(), GridItem(), GridItem()]

    // MARK: Data shared with me
    var viewModel: RunViewModel
    var onFinish: (RunDetails) -> Void
        
    var body: some View {
        VStack{
            MapArea(coordinates: viewModel.coordinates, isActive: true)
                .opacity(viewModel.runState == .running ? 0 : 1)
                .frame(maxHeight: viewModel.runState == .running ? 0 : 260)
            
            VStack(spacing: 22) {
                LazyVGrid(columns: columns, spacing: 10){
                    if viewModel.runState == .running {
                        activeStateStats
                    } else { pausedStateStats }
                }
                
                if viewModel.runState == .running{
                    Spacer()
                    Spacer()
                    StatItem(label: "miles", value: RunFormatter.distance(viewModel.distance), size: StatSize.large)
                }
                
                Spacer()
                
                activeButtons
               
                Spacer()
                ConnectMusicButton()
            }
            .padding(20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background( viewModel.runState == .running ? .blue.opacity(0.7) : .white)
    }
    
    var activeButtons: some View {
        HStack(spacing: 24) {
            if showPause {
                CircleActionButton(bgColor: .black, textColor:.white, img: "pause.fill", size:ButtonSize.medium) {
                    showPause = false
                    withAnimation(.easeInOut(duration: 0.2)){
                        viewModel.pauseRun()
                    }
                }
            }
            
            if viewModel.runState == .paused {
                CircleActionButton(bgColor: .black, textColor:.white, img:"stop.fill", size:ButtonSize.medium) { viewModel.pauseRun() }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 1.5)
                        .onEnded{_ in
                            if viewModel.distance < 100{
                                viewModel.cancelRun()
                                dismiss()
                            } else {
                                let run = viewModel.finishRun()
                                onFinish(run)
                                modelContext.insert(run)
                                notifyManager.schedulePostRunNotification(distance: run.distance, duration: run.activeTime)
                                Task{
                                    guard let token = await authManager.getToken() else { return }
                                    await viewModel.saveRun(token: token, run:run)
                                }
                            }
                        }
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation(.easeInOut(duration: 2)) {
                                holdScale = 1.4 }
                        }
                        .onEnded { _ in
                            withAnimation(.easeInOut(duration: 0.3)) { holdScale = 1.0 }
                        }
                )
                .scaleEffect(holdScale)
                .transition(.asymmetric(
                    insertion: .offset(x: 40),
                    removal: .offset(x: 40)
                ))
                CircleActionButton(bgColor: .blue.opacity(0.7), textColor:.black, img: "play.fill", size:ButtonSize.medium) {
                    withAnimation(.easeInOut(duration: 0.2)){
                        viewModel.resumeRun()
                    } completion: { showPause = true }
                }
                .transition(.asymmetric(
                    insertion: .offset(x: -40),
                    removal: .offset(x: -40)
                ))
            }
        }
        .animation(.easeInOut(duration:0.2), value: viewModel.runState)
        .frame(height:80)
    }
    
    var pausedStateStats: some View {
        Group{
            StatItem(label: "miles", value: RunFormatter.distance(viewModel.distance))
            StatItem(label: "Avg Pace", value: RunFormatter.pace(viewModel.avgPace))
            StatItem(label: "Time", value: RunFormatter.duration(viewModel.activeTime))
            StatItem(label: "Calories", value: "--")
            StatItem(label: "Elevation", value: RunFormatter.elevation(viewModel.elevation))
            StatItem(label: "BPM", value: "--")
        }
    }
    
    var activeStateStats: some View {
        Group{
            StatItem(label: "Avg Pace", value: RunFormatter.pace(viewModel.avgPace))
            StatItem(label: "BPM", value: "--")
            StatItem(label: "Time", value: RunFormatter.duration(viewModel.activeTime))
        }
    }
    
}

#Preview {
    @Previewable @State var viewModel = RunViewModel()
    ActiveRunView(viewModel: viewModel){ _ in
        let text = Text("Active completed")
    }
    .modelContainer(for: RunDetails.self, inMemory: true)
}
