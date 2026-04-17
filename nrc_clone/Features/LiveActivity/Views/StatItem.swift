//
//  StatItem.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import SwiftUI

enum StatSize {
    case xSmall, small, medium, large
    
    var valueFont: Font {
        switch self {
        case .xSmall: .system(size: 18, weight: .semibold)
        case .small:  .system(size: 22, weight: .bold)
        case .medium: .system(size: 48, weight: .heavy)
        case .large:  .system(size: 86, weight: .heavy)
        }
    }
    
    var labelFont: Font {
        switch self {
        case .xSmall: .system(size: 12)
        case .small:  .caption
        case .medium: .subheadline
        case .large:  .title3
        }
    }
    
    var weight: Font.Weight {
        switch self {
        case .xSmall: .medium
        case .small:  .semibold
        case .medium: .heavy
        case .large:  .heavy
        }
    }
}

struct StatItem: View {
    let label: String
    let value: String
    var alignment: HorizontalAlignment = .center
    var size: StatSize = .small
    
    var body: some View {
        VStack (alignment: alignment, spacing: 4){
            Text(value)
                .font(size.valueFont)
                .italic(size == .medium || size == .large)
                .fontWeight(size.weight)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(size.labelFont)
                .foregroundStyle(.secondary)
                .tracking(0.8)
                .lineLimit(1)
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        StatItem(label: "Miles", value: "5.2", size: .large)
        StatItem(label: "Avg Pace", value: "8'42\"", size: .medium)
        HStack(spacing: 24) {
            StatItem(label: "Time", value: "45:12", alignment: .leading)
            StatItem(label: "Cadence", value: "172", alignment: .leading)
            StatItem(label: "Elevation", value: "312ft", alignment: .leading)
        }
        StatItem(label: "BPM", value: "158", size: .xSmall)
    }
    .padding()
}
