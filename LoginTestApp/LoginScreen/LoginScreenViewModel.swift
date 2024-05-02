//
//  LoginScreenViewModel.swift
//  LoginTestApp
//
//  Created by Федор Шашков on 02.05.2024.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class LoginViewModel: ObservableObject {
    @Published var isRegistrationScreenPresented = false
    @Published var isForgotPasswordScreenPresented = false
    @Published var email = ""
    @Published var password = ""
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var isLoggedIn = false

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.alertMessage = "Ошибка входа: \(error.localizedDescription)"
                self.showAlert = true
                print("Error logging in: \(error.localizedDescription)")
            } else {
                guard let user = Auth.auth().currentUser else {
                    print("User not found after successful login")
                    return
                }
                
                if user.isEmailVerified {
                    print("User logged in successfully")
                    self.isLoggedIn = true
                } else {
                    self.alertMessage = "Ваша электронная почта не подтверждена. Пожалуйста, проверьте свою почту и подтвердите адрес электронной почты."
                    self.showAlert = true
                    print("Email not verified")
                    do {
                        try Auth.auth().signOut()
                        print("logout success")
                    } catch let signOutError as NSError {
                        print("Error signing out: \(signOutError)")
                    }
                }
            }
        }
    }

    func googleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { user, error in
            
            if let error = error {
                self.alertMessage = "Ошибка аутентификации через Google: \(error.localizedDescription)"
                self.showAlert = true
                print("Error signing in with Google: \(error.localizedDescription)")
                return
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken
            else {
                self.alertMessage = "Ошибка получения данных пользователя"
                self.showAlert = true
                print("Error getting user data")
                return
            }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                
                guard error == nil else {
                    self.alertMessage = "Ошибка аутентификации через Firebase: \(error!.localizedDescription)"
                    self.showAlert = true
                    print("Error signing in with Firebase: \(error!.localizedDescription)")
                    return
                }
                self.isLoggedIn = true
                print("Google signin success")
            }
        }
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.alertMessage = "Ошибка при отправке инструкций по сбросу пароля: \(error.localizedDescription)"
                self.showAlert = true
                print("Error sending password reset instructions: \(error.localizedDescription)")
            } else {
                self.alertMessage = "Инструкции по сбросу пароля отправлены на ваш email"
                self.showAlert = true
                print("Password reset instructions sent successfully")
            }
        }
    }
    
    func checkSignIn() {
        if let _ = Auth.auth().currentUser {
            self.isLoggedIn = true
        }
    }
    
    private func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}



