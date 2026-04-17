//
//  CircleActionButton.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import SwiftUI

enum ButtonSize {
    case small
    case medium
    case large
}
struct CircleActionButton: View {
    let bgColor: Color
    let textColor: Color
    var img: String? = nil
    var text: String? = nil
    var size: ButtonSize = .large
    let action: () -> Void
    
    var frameSize: CGFloat {
        switch size {
        case .small: return 44
        case .medium: return 60
        case .large: return 80
        }
    }

    var iconSize: CGFloat {
        switch size {
        case .small: return 14
        case .medium: return 18
        case .large: return 24
        }
    }
    
    var textSize: CGFloat {
        switch size {
        case .small: return 14
        case .medium: return 14
        case .large: return 14
        }
    }
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        } label: {
            Circle()
                .frame(width: frameSize, height: frameSize)
                .foregroundStyle(bgColor)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .overlay {
                    if let img = img {
                        Image(systemName: img)
                            .foregroundStyle(textColor)
                            .font(.system(size: iconSize))
                    } else if let text = text {
                        Text(text)
                            .lineLimit(1)
                            .foregroundStyle(textColor)
                            .font(.system(size: textSize))
                            .fontWeight(.bold)
                    }
                }
        }
    }
}

//#Preview {
//    CircleActionButton()
//}
