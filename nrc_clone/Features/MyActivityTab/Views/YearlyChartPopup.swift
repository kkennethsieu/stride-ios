//
//  YearlyChartPopup.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/7/26.
//

import SwiftUI

struct YearlyChartPopup: View {
    var date: Date
    var miles: Double
    var time: Double
    var runs: Int
    var onSelect: () -> Void
    var body: some View {
        Button{ onSelect() }
        label:{
            VStack(alignment: .leading, spacing: 12) {
                HStack{
                    Text(RunFormatter.date(date))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                
                HStack(spacing: 20) {
                    StatItem(label: "Runs", value: "\(runs)", alignment: .leading, size: StatSize.xSmall)
                    StatItem(label: "Miles", value: RunFormatter.distance(miles * 1609.344), alignment: .leading, size: StatSize.xSmall)
                    StatItem(label: "Time", value: RunFormatter.duration(time), alignment: .leading, size: StatSize.xSmall)
                }
            }
            .foregroundStyle(.white)
            .padding(20)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        YearlyChartPopup(date: .now, miles: 24.3, time: 9600, runs: 8){ }
            .padding()
    }
}
