//
//  ContentView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import SwiftUI

struct ContentView: View {
    @State private var countdown: Int? = nil
    @Environment(AppRouter.self) var appRouter
    @Environment(NotificationManager.self) var notifyManager
    @Environment(SyncManager.self) var syncManager

    var body: some View {
        @Bindable var appRouter = appRouter
        
        ZStack{
            TabView(selection: $appRouter.selectedTab){
                RunView(countdown: $countdown)
                    .tag(AppRouter.Tab.run)
                    .tabItem { Label("Run", systemImage: "figure.run") }
                Group{
                    if syncManager.isLoading{
                        ProgressView("Syncing your runs...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else{
                        ActivityTabView()
                    }
                }
                    .tag(AppRouter.Tab.activity)
                    .tabItem { Label("Activity", systemImage: "chart.bar") }
            }
            .onChange(of: notifyManager.pendingRoute){_, route in
                guard let route else { return }
                switch route{
                case "activity": appRouter.selectedTab = .activity
                default: break
                }
                notifyManager.pendingRoute = nil
            }
            if let count = countdown {
                CountdownOverlay(count: count)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview(traits: .swiftData) {
    ContentView()
        .withAppEnvironment()
}
