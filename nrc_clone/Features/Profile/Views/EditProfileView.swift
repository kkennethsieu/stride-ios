//
//  EditProfileView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @State private var name: String = "Kenneth Sieu"
    @State private var hometown: String = ""
    @State private var bio: String = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil
    @State private var showPhotoOptions: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                avatarSection
                fieldsSection
            }
            .padding(20)
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Profile Photo", isPresented: $showPhotoOptions, titleVisibility: .visible) {
            VStack{
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Text("Choose Photo")
                }
                Button("Take Photo") {
                    // camera
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .onChange(of: selectedPhoto) {
            Task {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = Image(uiImage: uiImage)
                }
            }
        }
    }

    // MARK: Avatar
    var avatarSection: some View {
        VStack(spacing: 10) {
            Button {
                showPhotoOptions = true
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let profileImage {
                            profileImage
                                .resizable()
                                .scaledToFill()
                        } else {
                            Circle()
                                .fill(.secondary.opacity(0.15))
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 36))
                                        .foregroundStyle(.secondary)
                                }
                        }
                    }
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())

                    // edit badge
                    Circle()
                        .fill(Color(UIColor.systemBackground))
                        .frame(width: 28, height: 28)
                        .overlay {
                            Image(systemName: "pencil")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.primary)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            .buttonStyle(.plain)

            Text("Change Photo")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: Fields
    var fieldsSection: some View {
        VStack(spacing: 0) {
            ProfileField(icon: "person", label: "Name", placeholder: "Your name", text: $name)
            Divider().padding(.leading, 48)
            ProfileField(icon: "mappin", label: "Hometown", placeholder: "City, Country", text: $hometown)
            Divider().padding(.leading, 48)
            ProfileField(icon: "text.alignleft", label: "Bio", placeholder: "Tell your story", text: $bio, multiline: true)
        }
    }
    
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}
