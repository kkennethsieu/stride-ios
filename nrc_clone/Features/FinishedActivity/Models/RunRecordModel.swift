//
//  RunRecordModel.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/3/26.
//

import Foundation
import MapKit
import SwiftData

enum DistanceUnit {
    case miles
    case kilometers
    
    var splitThreshold: Double {
        switch self {
        case .miles: 1609.344
        case .kilometers: 1000.0
        }
    }
}

/*
 func barWidth(for split: Split, in splits: [Split]) -> Double {
     let fastest = splits.map(\.avgPace).min() ?? split.avgPace
     let slowest = splits.map(\.avgPace).max() ?? split.avgPace
     guard slowest != fastest else { return 1.0 }
     return 1.0 - ((split.avgPace - fastest) / (slowest - fastest))
 }
 PUT INSIDE VIEWMODEL
 */
