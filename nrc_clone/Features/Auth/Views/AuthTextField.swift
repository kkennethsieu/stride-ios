//
//  AuthTextField.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import SwiftUI

struct AuthTextField: View {
    var icon: String
    var title: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)

            TextField(title, text: $text)
                .foregroundStyle(.primary)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        .padding(14)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay{
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
        }
    }
}

struct AuthPasswordField: View {
    var icon: String
    var title: String
    @Binding var text: String

    @State private var isSecure: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)

            Group {
                if isSecure {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
            }
            .foregroundStyle(.primary)

            Button {
                isSecure.toggle()
            } label: {
                Image(systemName: isSecure ? "eye" : "eye.slash")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay{
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        AuthTextField(icon: "envelope", title: "Email", text: .constant(""))
        AuthTextField(icon: "envelope", title: "Email", text: .constant("ken@example.com"))
        AuthPasswordField(icon: "lock", title: "Password", text: .constant(""))
        AuthPasswordField(icon: "lock", title: "Password", text: .constant("secret123"))
    }
    .padding(24)
}
