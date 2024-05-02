//
//  RegistrationScreen.swift
//  LoginTestApp
//
//  Created by Федор Шашков on 30.04.2024.
//

import SwiftUI

struct RegistrationScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = RegistrationScreenViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Text("Регистрация")
                .fontWeight(.bold)
            
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            SecureField("Пароль", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            SecureField("Повторите пароль", text: $viewModel.confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                viewModel.checkPasswords()
            }) {
                Text("Зарегистрироваться")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Spacer()
            Spacer()
            
            
        }
        .padding()
        
        .alert(isPresented: $viewModel.isShowingAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("ОК")) {
                    if viewModel.alertTitle == "Успешная регистрация" {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}



struct RegistrationScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationScreen()
    }
}


