//
//  SplashScreenView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/8/26.
//

import SwiftUI
import Lottie

struct SplashScreenView: View {
    
    @State private var showText: Bool = false
    @State private var opacity: Double = 1.0

    var onFinish: () -> Void
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.9).ignoresSafeArea()
            
            HStack(spacing:8){
                if showText{
                    StrideLogo(logoSize:.medium)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)

        }
        .opacity(opacity)
        .onAppear{
            withAnimation(.spring(duration: 1.0)){
                showText = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeOut(duration: 0.4)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    onFinish()
                }
            }
            
        }
    }
}

#Preview {
    SplashScreenView(){}
}
