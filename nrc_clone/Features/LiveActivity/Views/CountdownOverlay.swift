//
//  CountdownOverlay.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/2/26.
//

import SwiftUI

struct CountdownOverlay: View {
    // MARK: Data Owned By Me
    @State private var scale: CGFloat = 0.6
    @State private var opacity: CGFloat = 0.0
    
    // MARK: Data shared with me
    var count: Int = 3
    
    var body: some View {
        VStack{
            Text("\(count)")
                .font(.system(size:100, weight:.bold, design: .default).italic())
                .foregroundStyle(.blue)
                .contentTransition(.numericText())
                .opacity(opacity)
                .scaleEffect(scale)
            
                .onAppear{
                    withAnimation(.easeInOut(duration: 0.3)) {
                        opacity = 1.0
                        scale = 1.6
                    }
                }
                .onChange(of: count){
                    scale = 0.6
                    opacity = 0.0
                    withAnimation(.easeInOut(duration:0.3)){
                        scale = 1.6
                        opacity = 1.0
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: opacity)
                .animation(.easeInOut(duration: 0.3), value: scale)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}


#Preview {
    @Previewable @State var count: Int? = 3
    ZStack{
        if let c = count {
            CountdownOverlay(count: c)
        }
    }
    .onAppear{
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
            if let current = count {
                if current <= 1{
                    timer.invalidate()
                    count = nil
                } else {
                    count = current - 1
                }
            }
        }
    }
}
