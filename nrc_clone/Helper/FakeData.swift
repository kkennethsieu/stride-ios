//
//  FakeData.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/8/26.
//

import SwiftData
import Foundation

func insertFakeData(into context: ModelContext) {
    let calendar = Calendar.current
    for offset in 0..<30 {
        let date = calendar.date(byAdding: .day, value: -offset, to: .now)!
        let distance = Double.random(in: 3000...15000)
        let activeTime = distance * Double.random(in: 0.33...0.42)
        let run = RunDetails(
            name: "Run \(offset)",
            date: date,
            distance: distance,
            activeTime: activeTime,
            avgPace: activeTime / distance
        )
        context.insert(run)
    }
}
