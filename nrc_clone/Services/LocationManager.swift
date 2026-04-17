//
//  LocationManager.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import Foundation
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    // need location because it contains .coordinate, .speed, .altitude, .timestamp.
    var currLocation: [CLLocation] = []
    var distance: Double = 0.0
    
    // Splits
    private var nextSplitDistance: Double = 1609.34
    private var splitStartTime: Date? = nil
    // the amount we pause by
    private var splitPausedTime: Double = 0.0
    // the time we started the pause
    private var pauseStartTime: Date? = nil
    
    var splits: [Split] = []
    var splitElevation: Double = 0.0
    
    // fastest pace
    var fastestPace: Double = 0.0
    // elevation
    var elevationGain: Double = 0.0 {
        didSet { print("elevationGain: \(elevationGain)") }
    }
    var elevationLoss: Double = 0.0{
        didSet { print("elevationLoss: \(elevationLoss)") }
    }
    
    var isTracking: Bool = false
    var isNewLocationAfterResume = false
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //
        locationManager.distanceFilter = 10 // only fires if user moves 10 meters
        locationManager.activityType = .fitness // tracks more aggressively if fitness
        // allows to track when app is in the background
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        // shows a blue bar at the top when tracking in background
        locationManager.showsBackgroundLocationIndicator = true
    }
    
    func startTracking() {
        if let pauseStart = pauseStartTime{
            splitPausedTime += Date().timeIntervalSince(pauseStart)
            pauseStartTime = nil
        }
        
        if splitStartTime == nil {
            splitStartTime = .now
        } 
        
        isTracking = true
        isNewLocationAfterResume = true
        locationManager.startUpdatingLocation()
    }
    
    func pauseTracking() {
        isTracking = false
        pauseStartTime = .now
        locationManager.stopUpdatingLocation()
    }
    
    func finishTracking(){
        isTracking = false
        locationManager.stopUpdatingLocation()
        if distance > 0, let splitStart = splitStartTime {
            let splitDuration = Date().timeIntervalSince(splitStart) - splitPausedTime
            let splitDistance = distance - (nextSplitDistance - 1609.34)
            let splitPace = splitDuration / splitDistance
            let newSplit = Split(
                distance: splitDistance,
                duration: splitDuration,
                avgPace: splitPace,
                elevation: splitElevation
            )
            if fastestPace == 0 || splitPace < fastestPace {
                fastestPace = splitPace
            }
            splits.append(newSplit)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isTracking else { return }
        guard let location = locations.last else { return }
        
        // this is after we pause/resume
        if isNewLocationAfterResume {
            currLocation.append(location)
            isNewLocationAfterResume = false
            return
        }
        
        // a new valid location
        if let previous = self.currLocation.last {
            // TOTAL distance
            distance += location.distance(from: previous)
            
            // TOTAL elevation
            let elevation = location.altitude - previous.altitude
            if elevation > 0 {
                elevationGain += elevation }
            else { elevationLoss += abs(elevation) }
            splitElevation += elevation
                        
            //SPLITs
            if distance >= nextSplitDistance {
                let splitDuration = location.timestamp.timeIntervalSince(splitStartTime ?? location.timestamp) - splitPausedTime
                let splitPace = splitDuration / 1609.34 // we want seconds per meter per mile
                let newSplit = Split(
                    distance: nextSplitDistance,
                    duration: splitDuration,
                    avgPace: splitPace,
                    elevation: splitElevation
                )
                if fastestPace == 0 || splitPace < fastestPace {
                    fastestPace = splitPace
                }
                
                splits.append(newSplit)
                nextSplitDistance += 1609.34
                splitStartTime = location.timestamp
                splitElevation = 0.0
                splitPausedTime = 0.0
            }
        }
        currLocation.append(location)
    }
    
    func reset() {
        currLocation = []
        distance = 0.0
        nextSplitDistance = 1609.34
        splitStartTime = nil
        splitPausedTime = 0.0
        pauseStartTime = nil
        splits = []
        splitElevation = 0.0
        fastestPace = 0.0
        elevationGain = 0.0
        elevationLoss = 0.0
        isTracking = false
        isNewLocationAfterResume = false
    }
}
