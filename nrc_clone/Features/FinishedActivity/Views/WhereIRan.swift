//
//  WhereIRan.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/6/26.
//

import SwiftUI

enum WhereIRanOptions: String, CaseIterable {
    case road = "Road"
    case track = "Track"
    case trail = "Trail"
    
    var icon: String {
        switch self {
        case .road: return "road.lanes"
        case .track: return "oval"
        case .trail: return "tree"
        }
    }
}

struct WhereIRan: View {
    // MARK: Data in
    @Environment(\.dismiss) var dismiss
    //MARK: Data shared with me
    @Binding var whereIRan: String?
    
    let options: [(label: String, icon: String, value: String)] = [
        ("Road", "road.lanes", "road"),
        ("Track", "oval", "track"),
        ("Trail", "tree", "trail")
    ]
    
    var body: some View {
        VStack(spacing:48){
            VStack (spacing: 8){
                Text("Where I Ran")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Where did you run?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                ForEach(WhereIRanOptions.allCases, id: \.self){option in
                    let isSelected = whereIRan == option.rawValue
                    
                    Button {
                        whereIRan = option.rawValue
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dismiss()
                        }
                    } label: {
                        VStack(spacing: 12) {
                            Image(systemName: option.icon)
                                .font(.system(size: 28))
                                .foregroundStyle(isSelected ? .primary : .tertiary)
                            Text(option.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                    .animation(.snappy, value: whereIRan)
                }

            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var whereIRan: String? = ""
    WhereIRan(whereIRan: $whereIRan)
}
