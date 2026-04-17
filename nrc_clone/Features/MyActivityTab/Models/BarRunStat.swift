//
//  BarRunStat.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/8/26.
//

import Foundation

struct BarRunStat: Identifiable {
    let id = UUID()
    let label: String
    let actualDate: Date
    let miles: Double
}
