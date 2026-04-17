//
//  SettingsRow.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//


import SwiftUI

struct SettingsRow<Trailing: View>: View {
    var icon: String
    var label: String
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .frame(width: 24)
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
            Spacer()
            trailing()
        }
        .padding(14)
    }
}
