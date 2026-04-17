//
//  MapSnapshotView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/8/26.
//

import SwiftUI
import MapKit

struct MapSnapshotView: View {
    let coordinates: [CLLocationCoordinate2D]
    @State private var snapshot: UIImage? = nil

    var body: some View {
        Group {
            if let snapshot {
                Image(uiImage: snapshot)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(.tertiary.opacity(0.3))
            }
        }
        .task {
            snapshot = await makeSnapshot()
        }
    }
    
    func makeSnapshot() async -> UIImage? {
        guard !coordinates.isEmpty else { return nil }
        
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(coordinates: coordinates)
        options.size = CGSize(width: 120, height: 120)
        options.scale = 3
        
        let snapshotter = MKMapSnapshotter(options: options)
        guard let snapshot = try? await snapshotter.start() else { return nil }
        
        // Draw the polyline on top of the snapshot
        let renderer = UIGraphicsImageRenderer(size: options.size)
        return renderer.image { _ in
            snapshot.image.draw(at: .zero)
            
            let path = UIBezierPath()
            path.lineWidth = 3
            
            let points = coordinates.map { snapshot.point(for: $0) }
            guard let first = points.first else { return }
            path.move(to: first)
            points.dropFirst().forEach { path.addLine(to: $0) }
            
            UIColor.systemBlue.setStroke()
            path.stroke()
        }
    }
}

//#Preview {
//    MapSnapshotView()
//}
