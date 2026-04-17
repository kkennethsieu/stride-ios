//
//  NotesView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//

import SwiftUI

struct NotesView: View {
    // MARK: Data shared with me
    @Binding var notes: String
    
    // MARK: Data owned by me
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack{
            TextField("Enter notes", text: $notes, axis:.vertical)
                .font(.body)
                .focused($isFocused)
            
            Spacer()
        }
        .onAppear{
            isFocused = true
        }
        .padding()
        .navigationTitle("Notes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var notes: String = ""
    NavigationStack{
        NotesView(notes: $notes)
    }
}
