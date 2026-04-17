//
//  SplitRow.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/3/26.
//

import SwiftUI

struct SplitRow: View {
    let split: Split
    let index: Int
    
    var body: some View {
        HStack {
            Text(split.distance < 1609 ? RunFormatter.distance(split.distance) : "\(index + 1)")
                .frame(width: 40, alignment: .leading)
                .fontWeight(.medium)
            GeometryReader{ geo in
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundStyle(.tertiary.opacity(0.4))
                        .frame(width: geo.size.width * 0.3)
                    // NEED TO FIX THE BARWIDTH
//                        .frame(width: geo.size.width * split.barWidth)
                    Text("\(RunFormatter.pace(split.avgPace))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                }
            }
            .frame(height: 38)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(RunFormatter.elevation(split.elevation))
                .frame(width: 80, alignment: .trailing)
                .font(.subheadline)
        }
    }
}

//#Preview {
//    SplitRow()
//}

