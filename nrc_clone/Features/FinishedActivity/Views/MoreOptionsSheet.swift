//
//  MoreOptionsSheet.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/7/26.
//

import SwiftUI

struct MoreOptionsSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectEdit: Bool
    @Binding var selectDelete: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(.systemGray4))
                .frame(width: 36, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 24)
            
            VStack(spacing: 0) {
                optionRow(icon: "square.and.arrow.up", label: "Share Run") { }
                Divider().padding(.leading, 52)
                optionRow(icon: "pencil", label: "Edit Run") {
                    selectEdit = true
                    dismiss()
                }
                Divider().padding(.leading, 52)
                optionRow(icon: "trash", label: "Remove Run", destructive: true) {
                    selectDelete = true
                    dismiss()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func optionRow(icon: String, label: String, destructive: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundStyle(destructive ? .red : .primary)
                Text(label)
                    .foregroundStyle(destructive ? .red : .primary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var selectEdit: Bool = false
    @Previewable @State var selectDelete: Bool = false

    MoreOptionsSheet(selectEdit: $selectEdit, selectDelete: $selectDelete)
}
