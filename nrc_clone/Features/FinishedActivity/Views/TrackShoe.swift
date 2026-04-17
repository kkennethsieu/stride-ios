//
//  TrackShoe.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/3/26.
//

import SwiftUI

struct TrackShoe: View {
    var body: some View {
        VStack (alignment:.leading, spacing:18){
            HStack{
                Text("Add your shoes")
                    .font(.headline)
                Spacer()
                Button("Add", systemImage: "plus") {
                    // add ACTION
                }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.plain)
            }
            
            Text("We'll track their mileage and remind you as you approach your goal")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Image(systemName: "shoe")
                .font(.system(size:80))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .padding(20)
        .background(.tertiary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    TrackShoe()
}
