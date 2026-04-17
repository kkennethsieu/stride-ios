//
//  ProfileView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import SwiftUI

struct Friend {
    var name: String
}

struct ProfileView: View {
    // MARK: Data In
    @Environment(\.dismiss) var dismiss
    
    // MARK: Data owned by me
    @State private var showEditProfile: Bool = false
    @State private var showSettings: Bool = false
    
    var friends: [Friend] = [Friend(name: "Alex"), Friend(name: "Sam"), Friend(name: "Edgar"), Friend(name: "Edgar"), Friend(name: "Edgar"),Friend(name: "Edgar"),Friend(name: "Edgar"),Friend(name: "Edgar")]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing:40){
                    profileHeader
                    quickActions
                    infoSection
                    friendsSection
                    
                }
                .padding(20)
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationDestination(isPresented: $showEditProfile){
                EditProfileView()
            }
            .navigationDestination(isPresented: $showSettings){
                SettingsView()
            }
        }
    }
    
    // MARK: Header
     var profileHeader: some View {
         VStack(spacing: 12) {
             Circle()
                 .fill(.secondary.opacity(0.15))
                 .frame(width: 90, height: 90)
                 .overlay {
                     Image(systemName: "person.fill")
                         .font(.system(size: 36))
                         .foregroundStyle(.secondary)
                 }

             VStack(spacing: 4) {
                 Text("Kenneth Sieu")
                     .font(.title3)
                     .fontWeight(.semibold)

                 Text("@ken")
                     .font(.subheadline)
                     .foregroundStyle(.secondary)
             }

             ClearActionButton(text: "Edit Profile", size:.small) {
                 showEditProfile = true
             }
                 .frame(maxWidth: 160)
         }
     }
    
    // MARK: Quick Actions
    var quickActions: some View {
        HStack(spacing: 0) {
            QuickActionButton(icon: "shoe", label: "My Shoes") {}
            Divider()
            QuickActionButton(icon: "barcode.viewfinder", label: "Pass") {}
            Divider()
            QuickActionButton(icon: "calendar", label: "Events") {}
            Divider()
            QuickActionButton(icon: "gear", label: "Settings") {
                showSettings = true
            }
        }
        .padding(.vertical, 16)
    }
    
    // MARK: Info Rows
    var infoSection: some View {
        VStack(spacing: 12) {
            ProfileRow(icon: "tray", title: "Inbox", subtitle: "View messages") {}
            ProfileRow(icon: "star", title: "Stride Member Benefits", subtitle: "No unlocks yet") {}
        }
    }
    
    // MARK: Friends Section
    
    var friendsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Friends")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(friends.indices, id:\.self){index in
                        VStack(spacing: 6) {
                            Circle()
                                .fill(.secondary.opacity(0.15))
                                .frame(width: 52, height: 52)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.secondary)
                                }
                            Text(friends[index].name)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .scrollTargetLayout()
                
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, 16)
            
            ClearActionButton(text: "Add Friends") {}
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack{
        ProfileView()
    }
    .withAppEnvironment()
}
