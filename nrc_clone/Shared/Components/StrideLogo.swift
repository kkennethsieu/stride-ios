//
//  StrideLogo.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import SwiftUI

struct StrideLogo: View {
    enum LogoSize {
        case small, medium, large

        var textSize: CGFloat {
            switch self {
            case .small:  return 28
            case .medium: return 42
            case .large:  return 64
            }
        }

        var kerning: CGFloat {
            switch self {
            case .small:  return 4
            case .medium: return 6
            case .large:  return 8
            }
        }

        var taglineKerning: CGFloat {
            switch self {
            case .small:  return 2
            case .medium: return 3
            case .large:  return 4
            }
        }
    }

    var logoSize: LogoSize = .medium
    var color: Color = .white
    var showTagline: Bool = true

    var body: some View {
        VStack(spacing: 6) {
            Text("STRIDE")
                .font(.system(size: logoSize.textSize, weight: .bold))
                .kerning(logoSize.kerning)

            if showTagline {
                Text("RUN · TRACK · CONQUER")
                    .font(.system(size: logoSize.textSize * 0.21, weight: .regular))
                    .kerning(logoSize.taglineKerning)
                    .foregroundStyle(color.opacity(0.6))
            }
        }
        .foregroundStyle(color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Stride — run, track, conquer")
    }
}

#Preview {
//    VStack(spacing: 0) {
//
//        // DARK BG
//        VStack(spacing: 40) {
//            StrideLogo(logoSize: .large)
//            StrideLogo(logoSize: .medium)
//            StrideLogo(logoSize: .small)
//            StrideLogo(logoSize: .small, showTagline: false)
//        }
//        .frame(maxWidth: .infinity)
//        .padding(40)
//        .background(Color.black)
//
//        // LIGHT BG
//        VStack(spacing: 40) {
//            StrideLogo(logoSize: .large, color: .black)
//            StrideLogo(logoSize: .small, color: .black, showTagline: false)
//        }
//        .frame(maxWidth: .infinity)
//        .padding(40)
//        .background(Color.white)
//    }
//    .ignoresSafeArea()
    
    StrideLogo(logoSize: .large, showTagline: false)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
        .background(Color.black)

}
