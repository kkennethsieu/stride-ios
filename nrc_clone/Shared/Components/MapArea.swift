//
//  MapArea.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/3/26.
//

import SwiftUI
import MapKit

enum MapSize {
    case small
    case medium
    case large
}

struct MapArea: View {
    let coordinates: [CLLocationCoordinate2D]
    var isActive: Bool
    var enableMovement: Bool = false
    
    var region: MapCameraPosition {
        guard !coordinates.isEmpty else { return .automatic }
        return .region(MKCoordinateRegion(
            coordinates: coordinates
        ))
    }
        
    var body: some View {
        if enableMovement || isActive {
            Map(position: .constant(isActive ? .userLocation(fallback: .automatic) : region)) {
                if isActive {
                    UserAnnotation()
                }
                MapPolyline(coordinates: coordinates)
                    .stroke(.blue, lineWidth: 4)
            }
            .disabled(!enableMovement)
        } else {
            MapSnapshotView(coordinates: coordinates)
        }
    }
}


extension MKCoordinateRegion {
    init(coordinates: [CLLocationCoordinate2D]) {
        let lats = coordinates.map(\.latitude)
        let lons = coordinates.map(\.longitude)
        let center = CLLocationCoordinate2D(
            latitude: (lats.max()! + lats.min()!) / 2,
            longitude: (lons.max()! + lons.min()!) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: (lats.max()! - lats.min()!) * 3.0,
            longitudeDelta: (lons.max()! - lons.min()!) * 3.0
        )
        self.init(center: center, span: span)
    }
}

#Preview {
    MapArea( 
        coordinates: [
            CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437),
            CLLocationCoordinate2D(latitude: 34.0530, longitude: -118.2450),
            CLLocationCoordinate2D(latitude: 34.0545, longitude: -118.2460),
            CLLocationCoordinate2D(latitude: 34.0560, longitude: -118.2445),
        ],
        isActive: false
    )
}
