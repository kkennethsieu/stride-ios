//
//  RootView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/8/26.
//

import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    @Environment(AuthManager.self) var authManager
    @Environment(NotificationManager.self) var notifyManager
    @Environment(\.modelContext) var modelContext
    @Environment(SyncManager.self) var syncManager
    
    var body: some View {
        Group{
            if showSplash{
                SplashScreenView(){
                    withAnimation(.spring(duration: 0.6)) { showSplash = false }
                }
            } else {
                if authManager.isLoggedIn{
                    ContentView()
                        .task{
                            await notifyManager.requestPermission()
                            guard let token = await authManager.getToken() else {return}
                            syncManager.startMonitoring(token: token, context: modelContext)
                            try? await syncManager.pushPending(token: token, context: modelContext)
                            if UserDefaults.standard.object(forKey: "lastSyncedAt") != nil{
                                try? await syncManager.pullDelta(token: token, context: modelContext)
                            } else {
                                await syncManager.pullFreshRuns(token: token, context: modelContext)
                            }
                        }
                        .transition(.opacity)
                } else { GetStartedView()
                    .transition(.opacity) }
            }
        }
    }
}

#Preview {
    RootView()
        .withAppEnvironment()
}
