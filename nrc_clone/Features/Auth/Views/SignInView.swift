//
//  LoginView.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/13/26.
//

import SwiftUI
import AuthenticationServices
import GoogleSignInSwift

struct SignInView: View {
    // MARK: Data in
    @Environment(AuthManager.self) var vm
    
    @Binding var path: NavigationPath
    
    // MARK: Data owned by me
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginError: String? = nil
    @State private var isRemember: Bool = false
    
    var body: some View {
        VStack (spacing: 12){
            header
            
            // Text Fields
            VStack(spacing: 10){
                VStack {
                    AuthTextField(icon: "envelope", title: "Enter your email", text: $email)
                    AuthPasswordField(icon: "lock", title: "Enter your password", text: $password)
                }
                
                HStack{
                    Button{ isRemember.toggle() }
                    label: {
                        HStack(spacing: 6) {
                            Image(systemName: isRemember ? "checkmark.square.fill" : "checkmark.square")
                                .foregroundStyle(isRemember ? Color.primary : Color.secondary )
                            Text("Remember Me")
                                .foregroundStyle(Color.secondary)
                        }
                        .font(.caption)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                
                Button("Forgot password?") {}
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
            }
             
            Spacer().frame(height: 24)
            
            VStack(spacing: 12) {
                if let error = vm.errorMessage ?? loginError, !error.isEmpty {
                    Text(error)
                        .foregroundStyle(Color.red)
                        .font(.caption)
                }
                
                ClearActionButton(text: vm.isLoading ? "Signing in..." : "Sign in", disabled: vm.isLoading) {
                    loginError = ""
                    guard !email.isEmpty, !password.isEmpty else {
                        loginError = "Please enter your email and password."
                        return
                    }
                    Task { await vm.signIn(email: email, password: password) }
                }

                OrLoginWithLine()

                logoSignInButtons
                
            }
            Spacer().frame(height: 32)

            footer
            Spacer().frame(height: 8)

        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
    
    var header: some View {
        VStack(spacing: 16) {
            StrideLogo(logoSize: .large, color: .primary)
            Text("Track every mile. Own every run.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
    
    var logoSignInButtons: some View {
        HStack(spacing: 12) {
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                // handle
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            
            GoogleSignInButton(scheme:.dark, style: .wide) {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let vc = windowScene.windows.first?.rootViewController else { return }
                Task { await vm.signInWithGoogle(presenting: vc) }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    var footer: some View {
        HStack (spacing: 4){
            Text("Don't have an account? ")
                .foregroundStyle(.secondary)
            Button("Create an account"){
                withAnimation (.easeInOut) { 
                    path.append(AppRoute.signup)
                }
            }
            .foregroundStyle(.primary)
            .fontWeight(.semibold)
        }
        .font(.footnote)
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    SignInView(path: $path)
        .environment(AuthManager())
}
