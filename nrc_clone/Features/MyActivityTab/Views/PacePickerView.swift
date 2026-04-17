//
//  PacePickerView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/7/26.
//
import SwiftUI

struct PacePickerView: View {
    @Binding var pace: Double
    @Environment(\.dismiss) var dismiss
    
    @State private var minutes: Int = 8
    @State private var seconds: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            header("Pace")
            
            HStack {
                Picker("Minutes", selection: $minutes) {
                    ForEach(4..<20, id: \.self) { m in
                        Text("\(m) min").tag(m)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("Seconds", selection: $seconds) {
                    ForEach(0..<60, id: \.self) { s in
                        Text("\(s) sec").tag(s)
                    }
                }
                .pickerStyle(.wheel)
            }
            
            Text("per mile")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 16)
        }
        .onDisappear {
            // pace stored as seconds per meter
            let secondsPerMile = Double(minutes * 60 + seconds)
            pace = secondsPerMile / 1609.344
        }
        .onAppear {
            let secondsPerMile = pace * 1609.344
            minutes = Int(secondsPerMile) / 60
            seconds = Int(secondsPerMile) % 60
        }
    }
}
