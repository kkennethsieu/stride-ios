//
//  NoRunsView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import SwiftUI

struct NoRunsView: View {
    
    // MARK: Data In
    @Environment(AppRouter.self) var appRouter
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.run.circle")
                .font(.system(size: 64))
                .foregroundStyle(.secondary.opacity(0.4))

            VStack(spacing: 6) {
                Text("No runs yet")
                    .font(.headline)
                Text("Lace up and hit the road.\nYour runs will show up here.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            ClearActionButton(text: "Go For a Run", backgroundColor: .primary, tintColor: .white){
                appRouter.selectedTab = .run
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    NoRunsView()
        .withAppEnvironment()
}
