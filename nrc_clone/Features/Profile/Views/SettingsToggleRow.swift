//
//  SettingsToggleRow.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import SwiftUI

// MARK: Settings Toggle Row
struct SettingsToggleRow: View {
    var icon: String
    var label: String
    @Binding var value: Bool

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
            Toggle("", isOn: $value)
                .labelsHidden()
        }
        .padding(14)
    }
}
