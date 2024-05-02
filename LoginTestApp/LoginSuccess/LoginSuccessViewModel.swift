//
//  LoginSuccessViewModel.swift
//  LoginTestApp
//
//  Created by Федор Шашков on 02.05.2024.
//

import Foundation
import FirebaseAuth

class LoginSuccessViewModel: ObservableObject {
    
    func signOut(completion: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()
            print("logout success")
            completion()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
}
