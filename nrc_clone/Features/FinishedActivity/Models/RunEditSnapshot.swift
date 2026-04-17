//
//  RunEditSnapshot.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/14/26.
//

import Foundation

struct RunEditSnapshot: Equatable {
    var effort: Double?
    var notes: String?
    var whereIRan: String?
    var photoURL: String?
    
    init(_ run: RunDetails) {
        self.effort = run.effort
        self.notes = run.notes
        self.whereIRan = run.whereIRan
        self.photoURL = run.photoURL
    }
}
