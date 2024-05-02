//
//  RegistrationScreenViewModel.swift
//  LoginTestApp
//
//  Created by Федор Шашков on 02.05.2024.
//

import Foundation
import FirebaseAuth

class RegistrationScreenViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isShowingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    func checkPasswords() {
        guard password == confirmPassword else {
            alertTitle = "Ошибка"
            alertMessage = "Пароли не совпадают"
            isShowingAlert = true
            return
        }
        register()
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.alertTitle = "Ошибка"
                self.alertMessage = error.localizedDescription
                self.isShowingAlert = true
                print("Error registering user: \(error.localizedDescription)")
            } else {
                authResult?.user.sendEmailVerification { error in
                    if let error = error {
                        self.alertTitle = "Ошибка"
                        self.alertMessage = error.localizedDescription
                        self.isShowingAlert = true
                        print("Error sending email verification: \(error.localizedDescription)")
                    } else {
                        self.alertTitle = "Успешная регистрация"
                        self.alertMessage = "Регистрация успешно завершена. Пожалуйста, проверьте вашу почту для завершения регистрации."
                        self.isShowingAlert = true
                        print("Email verification sent successfully")
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
    }
}
