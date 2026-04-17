//
//  SignupView.swift
//  quiz
//
//  Created by Kenneth Sieu on 3/20/26.
//

import SwiftUI
import AuthenticationServices
import GoogleSignInSwift

struct SignupView: View {
    @Binding var path: NavigationPath
    @Environment(AuthManager.self) var vm

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var signupError: String? = nil
    @State private var isRemember: Bool = false
    
    var body: some View {
        VStack (spacing: 12){
            header
            
            // Text Fields
            VStack(spacing: 10) {
                AuthTextField(icon: "envelope", title: "Email", text: $email)
                AuthPasswordField(icon: "lock", title: "Password", text: $password)
                AuthPasswordField(icon: "lock.fill", title: "Confirm password", text: $confirmPassword)
            
            }
            
            Spacer().frame(height: 24)
            
            VStack(spacing: 12) {
                if let error = vm.errorMessage ?? signupError, !error.isEmpty {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                ClearActionButton(text: vm.isLoading ? "Creating account..." : "Create account", disabled: vm.isLoading) {
                    signupError = ""
                    guard !email.isEmpty, !password.isEmpty else {
                        signupError = "Please enter your email and password."
                        return
                    }
                    guard password == confirmPassword else {
                        signupError = "Passwords do not match."
                        return
                    }
                    Task { await vm.signUp(email: email, password: password) }
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
            Text("Start your first mile today.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
    
    var logoSignInButtons: some View {
        HStack(spacing: 12) {
            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                // handle
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            GoogleSignInButton(scheme: .dark, style: .wide) {
                // handle
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    
    var footer: some View {
        HStack(spacing: 4) {
            Text("Already have an account? ")
                .foregroundStyle(.secondary)
            Button("Sign in") {
                withAnimation(.easeInOut) {
                    path.removeLast()
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

    SignupView(path: $path)
        .environment(AuthManager())
}

