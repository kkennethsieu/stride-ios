//
//  PostRunMetadata.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/3/26.
//

import SwiftUI
import PhotosUI

struct PostRunMetadata: View {
    // MARK: Data Owned By Me
    @State private var showEffortView = false
    @State private var showWhereIRanView = false
    @State private var showNotes = false
    @State private var showPhotoButton = false
    @State private var showCamera = false
    @State private var showLibrary = false
    @State private var photosPickerItem: PhotosPickerItem?
    
    // MARK: Data shared with me
    @Binding var photoURL: String?
    @Binding var effort: Double?
    @Binding var whereIRan: String?
    @Binding var notes: String?
    
    // MARK: Body
    var body: some View {
        VStack(alignment:.leading, spacing: 18){
                      
            // PHOTO
            Button{ showPhotoButton = true }
            label:{
                HStack{
                    Text("My Photo")
                        .font(.headline)
                    Spacer()
                    if photoURL != nil {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "plus")
                    }
                }
            }
            .confirmationDialog("", isPresented: $showPhotoButton, titleVisibility: .hidden){
                Button("Take Photo") {
                    withAnimation{
                        showCamera = true
                    }
                }
                Button("Choose from Library") {
                    withAnimation{
                        showLibrary = true
                    }
                }
                if photoURL != nil {
                    Button("Remove Photo", role: .destructive) {
                        withAnimation{
                            photoURL = nil
                        }
                    }
                }
            }
            .buttonStyle(.plain)
            .fullScreenCover(isPresented: $showCamera) {
                CameraPicker(imageURL: $photoURL)
                    .ignoresSafeArea()
            }
            .photosPicker(isPresented: $showLibrary, selection: $photosPickerItem, matching: .images)
            .onChange(of: photosPickerItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        photoURL = saveImageLocally(image)
                    }
                }
            }
            
            if let photoURL, let uiImage = UIImage(contentsOfFile: photoURL) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Divider()
            
            // EFFORT
            Button{ showEffortView = true }
            label:{
                HStack{
                    Text("My Effort")
                        .font(.headline)
                    Spacer()
                    if let effort { Text(String(format: "%.0f / 5", effort))
                    } else { Image(systemName: "plus") }
                }
            }
            .buttonStyle(.plain)
            
            Divider()
            
            // WHEREIRAN
            Button{ showWhereIRanView = true }
            label:{
                HStack{
                    Text("Where I Ran")
                        .font(.headline)
                    Spacer()
                    if let whereIRan, let option = WhereIRanOptions(rawValue: whereIRan) {
                        Image(systemName: option.icon)
                    } else { Image(systemName: "plus") }
                }
            }
            .buttonStyle(.plain)
            
            Divider()
            
            // NOTES
            Button{ showNotes = true }
            label:{
                VStack(alignment: .leading ){
                    HStack{
                        Text("Notes")
                            .font(.headline)
                        Spacer()
                        if notes != nil{
                            Image(systemName: "pencil.and.list.clipboard")
                        } else { Image(systemName: "plus") }
                    }
                    if let notes {
                        VStack(alignment:.leading){
                            Text(notes)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .navigationDestination(isPresented: $showEffortView) {
            MyEffort(currentEffort: Binding(
                get: { effort ?? 1.0 },
                set: { effort = $0 }
            ))
        }
        .navigationDestination(isPresented: $showNotes) {
            NotesView(notes: Binding(
                get: { notes ?? "" },
                set: { notes = $0 }
            ))
        }
        .sheet(isPresented: $showWhereIRanView){
            WhereIRan(whereIRan: Binding(
                get: {whereIRan ?? "road"},
                set: {whereIRan = $0 }
            ))
            .presentationDetents([.medium])
            .presentationBackground(.regularMaterial)
        }
    }
    
}

//#Preview {
//    PostRunMetadata()
//}
