//
//  RunDetailsModel.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/7/26.
//

import SwiftData
import Foundation
import MapKit

@Model
class RunDetails: Identifiable {
    
    var id = UUID()
    var date: Date
    @Relationship(deleteRule: .cascade) var splits: [Split]?

    var distance: Double // in meters
    
    var activeTime: Double // in seconds -> Duration
    var elapsedTime: Double? // in seconds

    var avgPace: Double // in seconds / meter
    var fastestPace: Double? // in seconds / meter
    
    var elevationGain: Double? // in meter
    var elevationLoss: Double? // in meters
    
    var avgHR: Double? // bpm
    var maxHR: Double? // bpm
    
    var startTime: Date?
    var endTime: Date?
    
    var coordinatesData: Data
    
    var coordinates: [CLLocationCoordinate2D] {
        get {
            let decoded = try? JSONDecoder().decode([RunCoordinate].self, from: coordinatesData)
            return decoded?.map(\.clCoordinate) ?? []
        }
    }
    var name: String
    
    var effort: Double?
    var whereIRan: String?
    var notes: String?
    var photoURL: String?
    
    var syncStatus: String
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String = RunFormatter.timeOfDay(Date.now),
        date: Date,
        splits: [Split] = [],
        distance: Double,
        activeTime: Double,
        elapsedTime: Double? = nil,
        avgPace: Double,
        fastestPace: Double? = nil,
        elevationGain: Double? = nil,
        elevationLoss: Double? = nil,
        avgHR: Double? = nil,
        maxHR: Double? = nil,
        startTime: Date? = nil,
        endTime: Date? = nil,
        coordinates: [CLLocationCoordinate2D] = [],
        effort: Double? = nil,
        whereIRan: String? = nil,
        notes: String? = nil,
        photoURL: String? = nil,
        syncStatus: String = "pending",
        updatedAt: Date = .now
    )
    {
        self.id = id
        self.name = name
        self.date = date
        self.splits = splits
        self.distance = distance
        self.activeTime = activeTime
        self.elapsedTime = elapsedTime
        self.avgPace = avgPace
        self.fastestPace = fastestPace
        self.elevationGain = elevationGain
        self.elevationLoss = elevationLoss
        self.avgHR = avgHR
        self.maxHR = maxHR
        self.startTime = startTime
        self.endTime = endTime
        
        let downsampled = coordinates.enumerated()
            .filter { $0.offset % 5 == 0 }
            .map { $0.element }
        
        let wrapped = downsampled.map { RunCoordinate(latitude: $0.latitude, longitude: $0.longitude) }
        self.coordinatesData = (try? JSONEncoder().encode(wrapped)) ?? Data()
        
        self.effort = effort
        self.whereIRan = whereIRan
        self.notes = notes
        self.photoURL = photoURL
        self.syncStatus = syncStatus
        self.updatedAt = updatedAt
    }
}

struct RunCoordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
