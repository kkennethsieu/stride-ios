//
//  MyEffort.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/3/26.
//

import SwiftUI

enum Effort: Int, CaseIterable {
    case extremelyLight = 1
    case veryLight = 2
    case light = 3
    case moderate = 4
    case hard = 5

    var title: String {
        switch self {
        case .extremelyLight: return "Extremely Light"
        case .veryLight:      return "Very Light"
        case .light:          return "Light"
        case .moderate:       return "Moderate"
        case .hard:           return "Hard"
        }
    }
    
    var description: String {
        switch self {
        case .extremelyLight: return "Easy breathing, could hold a full conversation"
        case .veryLight:      return "Comfortable pace, slightly elevated heart rate"
        case .light:          return "Noticeable effort, breathing harder"
        case .moderate:       return "Challenging, difficult to speak in full sentences"
        case .hard:           return "Max effort, unsustainable for long"
        }
    }
}

struct MyEffort: View {
    // MARK: Data shared with me
    @Binding var currentEffort: Double
    
    var effort: Effort {
        Effort(rawValue: Int(currentEffort.rounded())) ?? .extremelyLight
    }

    var body: some View {
        VStack(spacing:0){
            VStack (spacing: 16){
                Text(String(format: "%1.f", currentEffort))
                    .font(.system(size:86, weight:.bold, design: .default).italic())
                    .contentTransition(.numericText())
                    .animation(.snappy, value: currentEffort)

                Text(effort.title)
                    .font(.headline)
                
                Text(effort.description)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.vertical, 50)
            .foregroundStyle(.white)
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .background(.black)
            
            VStack{
                EffortSlider(value: $currentEffort, range: 1...5)
            }
            .frame(maxHeight:160)
            
        }
        .animation(.easeInOut, value: effort)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges:.bottom)
        .navigationTitle("Thursday Evening Run")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    @Previewable @State var currentEffort: Double = 2.0
    NavigationStack{
        MyEffort(currentEffort: $currentEffort)
    }
}
