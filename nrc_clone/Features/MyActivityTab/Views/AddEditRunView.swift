//
//  AddRunView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//

import SwiftUI
import SwiftData

struct AddEditRunView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var existingRun: RunDetails? = nil
    var isEditing: Bool { existingRun != nil }

    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var distance: Double = 0.0
    @State private var duration: Double = 0.0
    @State private var pace: Double = 0.0
    @State private var activeSheet: AddRunSheet? = nil
        
    enum AddRunSheet: Identifiable {
        case date, distance, duration, pace
        var id: Self { self }
    }
    
    var disabled: Bool {
        name.isEmpty || distance == 0 || duration == 0 || pace == 0
    }
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 0) {
                row {
                    Text("Name")
                    Spacer()
                    TextField("Optional", text: $name)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                row {
                    Text("Date")
                    Spacer()
                    Button { activeSheet = .date } label: {
                        Text(RunFormatter.dateAndTime(date))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                
                Divider()
                
                row {
                    Text("Distance")
                    Spacer()
                    Button { activeSheet = .distance } label: {
                        Text(distance == 0 ? "--" : "\(RunFormatter.distance(distance)) mi")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                
                Divider()
                
                row {
                    Text("Duration")
                    Spacer()
                    Button { activeSheet = .duration } label: {
                        Text(duration == 0 ? "--" : RunFormatter.duration(duration))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                
                Divider()
                
                row {
                    Text("Pace")
                    Spacer()
                    Button { activeSheet = .pace } label: {
                        Text(pace == 0 ? "--" : RunFormatter.pace(pace))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                                
                Spacer()
                ClearActionButton(text: "Save", backgroundColor: Color.black, tintColor:Color.white, disabled: disabled){
                    submitRun()
                }
            }
            .padding(.horizontal, 20)
            .navigationTitle("Add Run")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement:.primaryAction){
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear{
                if let run = existingRun {
                    name = run.name
                    date = run.date
                    distance = run.distance
                    duration = run.activeTime
                    pace = run.avgPace
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .date:
                    DatePicker("Date", selection: $date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .presentationDetents([.medium])
                case .distance:
                    DistancePickerView(distance: $distance)
                        .presentationDetents([.height(300)])
                case .duration:
                    DurationPickerView(duration: $duration)
                        .presentationDetents([.height(300)])
                case .pace:
                    PacePickerView(pace: $pace)
                        .presentationDetents([.height(300)])
                }
            }
        }
    }
    func submitRun(){
        if let run = existingRun {
            run.name = name
            run.date = date
            run.distance = distance
            run.activeTime = duration
            run.avgPace = pace
        } else {
            let newRun = RunDetails(
                name: name,
                date: date,
                distance: distance,
                activeTime: duration,
                avgPace: pace
            )
            modelContext.insert(newRun)
        }
        dismiss()
    }
    
    @ViewBuilder
    func row<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        HStack {
            content()
        }
        .padding(.vertical, 14)
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        AddEditRunView()
    }
}





// MARK: - Shared Header
@ViewBuilder
func header(_ title: String) -> some View {
    HStack {
        Text(title)
            .font(.headline)
        Spacer()
    }
    .padding()
    
    Divider()
}
