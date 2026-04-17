//
//  LocationPermissionManager.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/10/26.
//

import Foundation
import CoreLocation

@Observable
class LocationPermissionManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    // Auth status for background tracking
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    // for tracking
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
}
