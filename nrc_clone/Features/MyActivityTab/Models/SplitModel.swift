//
//  SplitModel.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/7/26.
//

import Foundation
import SwiftData

@Model
class Split {
    var id = UUID()
    var distance: Double
    var duration: Double
    var avgPace: Double
    var elevation: Double
    
    init(distance: Double, duration: Double, avgPace: Double, elevation: Double){
        self.distance = distance
        self.duration = duration
        self.avgPace = avgPace
        self.elevation = elevation
    }
}
