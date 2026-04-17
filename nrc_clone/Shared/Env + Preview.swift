//
//  Env + Preview.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/10/26.
//

import SwiftUI

extension View {
    func withAppEnvironment() -> some View {
        self
            .environment(AppRouter())
            .environment(LocationPermissionManager())
            .environment(AuthManager())
            .environment(NotificationManager())
            .environment(SyncManager())
    }
}
