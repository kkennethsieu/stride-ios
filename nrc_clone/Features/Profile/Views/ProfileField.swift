//
//  ProfileField.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//


import SwiftUI

struct ProfileField: View {
    var icon: String
    var label: String
    var placeholder: String
    @Binding var text: String
    var multiline: Bool = false
    
    var body: some View {
        HStack(alignment: multiline ? .top : .center, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .frame(width: 24)
                .padding(.top, multiline ? 14 : 0)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if multiline {
                    TextField(placeholder, text: $text, axis: .vertical)
                        .lineLimit(3...6)
                        .font(.subheadline)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.subheadline)
                }
            }
        }
        .padding(14)
    }
}
