//
//  SettingsView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AuthManager.self) var vm
    @Environment(SyncManager.self) var syncManager
    @Environment(\.modelContext) var modelContext
    
    @State private var notifyRaceDay: Bool = true
    @State private var notifyFriendActivity: Bool = false
    @State private var notifyWeeklyRecap: Bool = true
    @State private var showDeleteConfirm: Bool = false
    @State private var showLogoutConfirm: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                accountSection
                notificationsSection
                dangerSection
            }
            .padding(20)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Log Out", isPresented: $showLogoutConfirm, titleVisibility: .visible) {
            Button("Log Out", role: .destructive) {
                vm.signOut()
                syncManager.clearLocalData(context: modelContext)
            }
            Button("Cancel", role: .cancel) {}
        }
        .confirmationDialog("Delete Account", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete Account", role: .destructive) {
                Task { await vm.deleteAccount() }
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: Account
    var accountSection: some View {
        SettingsSection(title: "Account") {
            SettingsRow(icon: "envelope", label: "Email") {
                Text("ken@example.com")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: Notifications
    var notificationsSection: some View {
        SettingsSection(title: "Notifications") {
            SettingsToggleRow(icon: "flag", label: "Race Day Reminders", value: $notifyRaceDay)
            Divider().padding(.leading, 48)
            SettingsToggleRow(icon: "person.2", label: "Friend Activity", value: $notifyFriendActivity)
            Divider().padding(.leading, 48)
            SettingsToggleRow(icon: "chart.bar", label: "Weekly Recap", value: $notifyWeeklyRecap)
        }
    }

    // MARK: Danger Zone
    var dangerSection: some View {
        SettingsSection(title: "Account Actions") {
            Button {
                showLogoutConfirm = true
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 16))
                        .frame(width: 24)
                    Text("Log Out")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                }
                .foregroundStyle(.orange)
                .padding(14)
            }
            .buttonStyle(.plain)

            Divider().padding(.leading, 48)

            Button {
                showDeleteConfirm = true
            } label: {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .frame(width: 24)
                    Text("Delete Account")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                }
                .foregroundStyle(.red)
                .padding(14)
            }
            .buttonStyle(.plain)
        }
    }
}



#Preview {
    NavigationStack {
        SettingsView()
            .withAppEnvironment()
    }
}
