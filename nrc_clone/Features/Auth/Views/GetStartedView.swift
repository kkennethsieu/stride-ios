//
//  GetStartedView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import SwiftUI
import AVKit

struct GetStartedView: View {
    @State private var path = NavigationPath()
    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "bg_vid", withExtension: "mp4")!)
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(){
                PlayerView(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem,
                            queue: .main
                        ) { _ in
                            player.seek(to: .zero)
                            player.play()
                        }
                    }
                
                VStack(spacing: 18) {
                    StrideLogo(logoSize: .small)
                        .padding()
                        .padding(.top, 50)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                    headerText
                    
                    actionButtons
                    
                    termsAndCondition
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .login: SignInView(path: $path)
                case .signup: SignupView(path: $path)
                }
            }
        }
    }
    
    var headerText: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stride Run Club")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("Love it or hate it, we'll run with you.")
                .font(.title3)
                .foregroundStyle(.white.opacity(0.7))
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.white)
    }
    
    var actionButtons: some View {
        HStack(spacing: 10) {
            ClearActionButton(text: "Join Us", backgroundColor: Color.white, tintColor: Color.black) {
                path.append(AppRoute.signup)
            }
            ClearActionButton(text: "Sign In", backgroundColor: Color.clear, tintColor: Color.white) {
                path.append(AppRoute.login)
            }
        }
    }
    
    var termsAndCondition: some View {
        VStack {
            Text("By continuing you agree to our")
            Text("Terms & Conditions")
                .underline()
        }
        .font(.caption)
        .foregroundStyle(.white.opacity(0.6))
    }
}

enum AppRoute: Hashable {
    case login
    case signup
}

#Preview {
    GetStartedView()
        .environment(AuthManager())
}
