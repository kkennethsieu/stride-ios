//
//  AuthManager.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 4/10/26.
//

import FirebaseAuth
import Foundation
import GoogleSignIn

@Observable
class AuthManager {
    var user: User? = nil
    var isLoggedIn: Bool { user != nil }
    var isLoading = false
    var errorMessage: String? = nil
    var isRestoringSession = false
    
    init() {
        clearKeychainOnFirstLaunch()
        
        var isFirstEvent = true
        let _ = Auth.auth().addStateDidChangeListener { _, user in
            if isFirstEvent{
                self.isRestoringSession = true
                isFirstEvent = false
            } else {
                self.isRestoringSession = false
            }
            self.user = user
        }
    }
    
    private func clearKeychainOnFirstLaunch() {
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            try? Auth.auth().signOut()
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func signInWithGoogle(presenting viewController: UIViewController) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
            let user = result.user
            guard let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            let authResult = try await Auth.auth().signIn(with: credential)
            self.user = authResult.user
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func getToken() async -> String? {
        do {
            return try await user?.getIDToken()
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func deleteAccount() async {
        isLoading = true
        errorMessage = nil
        do {
            try await user?.delete()
            self.user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
