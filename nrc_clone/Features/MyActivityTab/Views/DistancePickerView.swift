//
//  DistancePickerView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/7/26.
//

import SwiftUI

struct DistancePickerView: View {
    @Binding var distance: Double
    @State private var selectedMiles: Double = 0.5
    
    @Environment(\.dismiss) var dismiss
    
    let distances: [Double] = Array(stride(from: 0.5, through: 50.0, by: 0.5))
    
    var body: some View {
        VStack(spacing: 0) {
            header("Distance")
            
            Picker("Distance", selection: $selectedMiles) {
                ForEach(distances, id: \.self) { d in
                    Text(String(format: "%.1f mi", d)).tag(d)
                }
            }
            .pickerStyle(.wheel)
            .onAppear { selectedMiles = distance / 1609.344 }
            .onDisappear { distance = selectedMiles * 1609.344 }
        }
    }
}

//#Preview {
//    DistancePickerView()
//}

