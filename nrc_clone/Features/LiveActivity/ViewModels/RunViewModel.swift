//
//  RunViewModel.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import Foundation
import CoreLocation

@Observable
class RunViewModel {
    let locationManager = LocationManager()
    // we want to show the startTimer in UI
    var errorMessage: String? = nil
    var startTime: Date? = nil
    var endTime: Date? = nil
    var runState: RunState
    var activeTime: Double = 0.0

    var elapsedTime: Double {
        guard let start = startTime, let end = endTime else { return 0 }
        return end.timeIntervalSince(start)
    }
    
    var coordinates: [CLLocationCoordinate2D] { locationManager.currLocation.map {$0.coordinate } }

    var distance: Double { locationManager.distance }
        
    var avgPace: Double {
        guard distance > 0 else { return 0 }
        return activeTime / distance  // seconds per meter
    }
    
    var elevation: Double {
        return locationManager.elevationGain - locationManager.elevationLoss
    }
        
    private var timer: Timer? = nil
        
    init(){
        self.runState = .idle
    }
    
    private func startTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){timer in
            self.activeTime += 1.0
        }
    }
    
    private func stopTimer(){
        self.timer?.invalidate()
        timer = nil
    }
    
    func startRun(){
        locationManager.reset()
        activeTime = 0.0
        runState = .running
        startTime = .now
        endTime = nil
        locationManager.startTracking()
        startTimer()
    }
    
    func resumeRun(){
        runState = .running
        locationManager.startTracking()
        startTimer()
    }
    
    func pauseRun(){
        runState = .paused
        locationManager.pauseTracking()
        stopTimer()
    }
    func cancelRun() {
        runState = .idle
        stopTimer()
        locationManager.reset()
        startTime = nil
        endTime = nil
        activeTime = 0.0
    }
    
    func finishRun() -> RunDetails {
        runState = .finished
        endTime = .now
        locationManager.finishTracking()
        stopTimer()
        
        let newRun = RunDetails(
            name: RunFormatter.timeOfDay(startTime ?? .now),
            date: startTime ?? .now,
            splits: locationManager.splits,
            distance: distance,
            activeTime: activeTime,
            elapsedTime: elapsedTime,
            avgPace: avgPace,
            fastestPace: locationManager.fastestPace,
            elevationGain: locationManager.elevationGain,
            elevationLoss: locationManager.elevationLoss,
            avgHR: 0,
            maxHR: 0,
            startTime: startTime ?? .now,
            endTime: .now,
            coordinates: coordinates
        )
        
        return newRun
    }
    
    func saveRun(token: String, run: RunDetails) async {
        if token.isEmpty{
            errorMessage = "Not authenticated."
            return
        }
        
        do{
            try await RunServiceAPI.shared.createRun(token: token, run: run)
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
