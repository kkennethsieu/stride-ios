//
//  DurationPickerView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/7/26.
//

import SwiftUI

struct DurationPickerView: View {
    @Binding var duration: Double
    @Environment(\.dismiss) var dismiss
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            header("Duration")
            
            HStack {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24, id: \.self) { h in
                        Text("\(h) hr").tag(h)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60, id: \.self) { m in
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
        }
        .onDisappear {
            duration = Double(hours * 3600 + minutes * 60 + seconds)
        }
        .onAppear {
            hours = Int(duration) / 3600
            minutes = (Int(duration) % 3600) / 60
            seconds = Int(duration) % 60
        }
    }
}
