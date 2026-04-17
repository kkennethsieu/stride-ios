//
//  RunDTO.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import Foundation
import CoreLocation

struct SplitDTO: Codable {
    var id: UUID
    var distance: Double
    var duration: Double
    var avgPace: Double
    var elevation: Double
}

struct RunDetailsDTO: Codable {

    var id: UUID
    var name: String
    var date: Date
    var splits: [SplitDTO]?

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
    
    var coordinates: [RunCoordinate]?
    
    var effort: Double?
    var whereIRan: String?
    var notes: String?
    var photoURL: String?
    
    var updatedAt: Date
    var isDeleted: Bool
}

// Need to make the data we fetch into the model data
extension SplitDTO {
    func toModel() -> Split {
        Split(
            distance: distance,
            duration: duration,
            avgPace: avgPace,
            elevation: elevation
        )
    }
}

// Need to make the data we fetch into the model data
extension RunDetailsDTO {
    func toModel() -> RunDetails{
        RunDetails(
            id:id,
            name: name,
            date: date,
            splits: splits?.map { $0.toModel() } ?? [],
            distance: distance,
            activeTime: activeTime,
            elapsedTime: elapsedTime,
            avgPace: avgPace,
            fastestPace: fastestPace,
            elevationGain: elevationGain,
            elevationLoss: elevationLoss,
            avgHR: avgHR,
            maxHR: maxHR,
            startTime: startTime,
            endTime: endTime,
            coordinates: coordinates?.map(\.clCoordinate) ?? [],
            effort: effort,
            whereIRan: whereIRan,
            notes: notes,
            photoURL: photoURL,
            syncStatus: "synced",
            updatedAt: updatedAt
        )
    }
}

// We need to make the model data into the fetch data for creating new

extension RunDetails {
    func toDTO() -> RunDetailsDTO {
        RunDetailsDTO(
            id: id,
            name: name,
            date: date,
            splits: splits?.map { SplitDTO(id: $0.id, distance: $0.distance, duration: $0.duration, avgPace: $0.avgPace, elevation: $0.elevation) },
            distance: distance,
            activeTime: activeTime,
            elapsedTime: elapsedTime,
            avgPace: avgPace,
            fastestPace: fastestPace,
            elevationGain: elevationGain,
            elevationLoss: elevationLoss,
            avgHR: avgHR,
            maxHR: maxHR,
            startTime: startTime,
            endTime: endTime,
            coordinates: coordinates.enumerated()
                .filter { $0.offset % 5 == 0 }
                .map { RunCoordinate(latitude: $0.element.latitude, longitude: $0.element.longitude) },
            effort: effort,
            whereIRan: whereIRan,
            notes: notes,
            photoURL: photoURL,
            updatedAt: updatedAt,
            isDeleted: false
        )
    }
}
