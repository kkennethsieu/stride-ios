//
//  MapDetailsView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//

import SwiftUI
import MapKit

struct MapDetailsView: View {
    let coordinates: [CLLocationCoordinate2D]
    var body: some View {
        MapArea(coordinates: coordinates, isActive: false, enableMovement: true)
    }
}

#Preview {
    let coordinates =     [
        CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
        CLLocationCoordinate2D(latitude: 32.7162, longitude: -117.1605),
        CLLocationCoordinate2D(latitude: 32.7168, longitude: -117.1598),
        CLLocationCoordinate2D(latitude: 32.7175, longitude: -117.1590),
        CLLocationCoordinate2D(latitude: 32.7181, longitude: -117.1582),
        CLLocationCoordinate2D(latitude: 32.7188, longitude: -117.1575),
        CLLocationCoordinate2D(latitude: 32.7194, longitude: -117.1568),
        CLLocationCoordinate2D(latitude: 32.7200, longitude: -117.1560),
        CLLocationCoordinate2D(latitude: 32.7206, longitude: -117.1553),
        CLLocationCoordinate2D(latitude: 32.7210, longitude: -117.1545),
        CLLocationCoordinate2D(latitude: 32.7208, longitude: -117.1537),
        CLLocationCoordinate2D(latitude: 32.7203, longitude: -117.1530),
        CLLocationCoordinate2D(latitude: 32.7197, longitude: -117.1523),
        CLLocationCoordinate2D(latitude: 32.7191, longitude: -117.1517),
        CLLocationCoordinate2D(latitude: 32.7185, longitude: -117.1510),
        CLLocationCoordinate2D(latitude: 32.7179, longitude: -117.1518),
        CLLocationCoordinate2D(latitude: 32.7173, longitude: -117.1525),
        CLLocationCoordinate2D(latitude: 32.7167, longitude: -117.1533),
        CLLocationCoordinate2D(latitude: 32.7161, longitude: -117.1540),
        CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
    ]
    MapDetailsView(coordinates: coordinates)
}
