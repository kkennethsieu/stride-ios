//
//  NoActivityCard.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/8/26.
//

import SwiftUI

struct NoActivityCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.run")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("No activity yet")
                .font(.headline)
            Text("Go for a run!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    NoActivityCard()
        .padding()
}
