//
//  EffortSlider.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//

import SwiftUI

struct EffortSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
        
    var body: some View {
        GeometryReader{ geo in
            let totalSteps = Int(range.upperBound - range.lowerBound) + 1
            let stepWidth = geo.size.width / CGFloat(totalSteps)
            let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)

            ZStack(alignment:.leading){
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Rectangle()
                    .fill(Color(red: 0.8, green: 1.0, blue: 0.2))
                    .frame(width: CGFloat(percent) * geo.size.width)
                
                HStack(spacing: 0) {
                    ForEach(0...totalSteps, id: \.self) { i in
                        VStack(spacing: 6) {
                            Rectangle()
                                .fill(.primary)
                                .frame(width: 1.5, height: 12)
                            Text("\(Int(range.lowerBound) + i)")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(.primary)
                        }
                        .frame(width: stepWidth)
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        let percent = min(max(drag.location.x / geo.size.width, 0), 1)
                        value = range.lowerBound + percent * (range.upperBound - range.lowerBound)
                    }
            )
            .frame(maxWidth:.infinity)
        }
    }
}

#Preview {
    @Previewable @State var value: Double = 3
    let range: ClosedRange<Double> = 1...5
    EffortSlider(value: $value, range:range)
        .onChange(of: value){
            print(value)
        }
}
