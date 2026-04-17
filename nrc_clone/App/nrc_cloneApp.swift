//
//  nrc_cloneApp.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import SwiftUI
import SwiftData
import FirebaseCore
import GoogleSignIn

@main
struct nrc_cloneApp: App {
    @State private var locationPermission = LocationPermissionManager()
    @State private var appRouter = AppRouter()
    @State private var notificationManager = NotificationManager()
    @State private var syncManager = SyncManager()
    
    var authManager: AuthManager

    init() {        
        FirebaseApp.configure()
        self.authManager = AuthManager()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(locationPermission)
                .environment(appRouter)
                .environment(authManager)
                .environment(notificationManager)
                .environment(syncManager)
                .preferredColorScheme(.light)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
        .modelContainer(for: RunDetails.self)
    }
}
