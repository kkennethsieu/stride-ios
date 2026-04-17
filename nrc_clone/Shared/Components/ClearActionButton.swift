//
//  ClearActionButton.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/3/26.
//

import SwiftUI

struct ClearActionButton: View {
    
    enum ButtonSize {
        case small, regular

        var paddingVertical: CGFloat {
            switch self {
            case .small:   return 10
            case .regular: return 18
            }
        }

        var font: Font {
            switch self {
            case .small:   return .caption
            case .regular: return .body
            }
        }
    }
    
    let text: String
    var size: ButtonSize = .regular
    var backgroundColor: Color = .clear
    var tintColor: Color = .primary

    var disabled: Bool = false

    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundStyle(disabled ? .secondary : tintColor)
                .font(size.font)
                .fontWeight(.semibold)
                .padding(.vertical, size.paddingVertical)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(disabled ? Color.gray.opacity(0.4) : backgroundColor)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(disabled ? .clear : tintColor, lineWidth: 1.0)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}

#Preview {
    VStack(spacing: 12) {
        ClearActionButton(text: "Regular", size: .regular) {}
        ClearActionButton(text: "Small", size: .small) {}
        ClearActionButton(text: "Small Black", size: .small, backgroundColor: .black, tintColor: .white) {}
        ClearActionButton(text: "Black Button", backgroundColor: .black, tintColor: .white) {}
        ClearActionButton(text: "White Button", backgroundColor: .white, tintColor: .black) {}
        ClearActionButton(text: "Disabled", disabled: true) {}
    }
    .padding()
}
