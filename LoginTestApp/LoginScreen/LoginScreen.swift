//
//  LoginScreen.swift
//  LoginTestApp
//
//  Created by Федор Шашков on 30.04.2024.
//

import SwiftUI

struct LoginScreen: View {
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Text("Логин")
                    .fontWeight(.bold)
                TextField("Введите ваш email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Пароль")
                    .fontWeight(.bold)
                SecureField("Введите ваш пароль", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: viewModel.login) {
                    Text("Войти")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(
                    destination: RegistrationScreen(),
                    isActive: $viewModel.isRegistrationScreenPresented
                ) {
                    Text("Зарегистрироваться")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: viewModel.googleSignIn) {
                    Text("Войти с помощью Google")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.isForgotPasswordScreenPresented = true
                }) {
                    Text("Забыли пароль?")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $viewModel.isForgotPasswordScreenPresented) {
                    ForgotPasswordScreen(isPresented: $viewModel.isForgotPasswordScreenPresented)
                }
                .navigationBarTitle("Назад")
                .navigationBarHidden(true)
                
            }
            .padding()
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Ошибка"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                viewModel.checkSignIn()
            }
            .background(
                NavigationLink(
                    destination: LoginSuccess(),
                    isActive: $viewModel.isLoggedIn,
                    label: { EmptyView() }
                )
            )
            
            
        }
    }
}


struct ForgotPasswordScreen: View {
    @ObservedObject var viewModel = LoginViewModel()
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Восстановление пароля")
                .fontWeight(.bold)
            
            TextField("Введите ваш email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: viewModel.resetPassword) {
                Text("Отправить инструкции по сбросу пароля")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                isPresented = false
            }) {
                Text("Отмена")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Успешно"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK")) {
                    isPresented = false
                }
            )
        }
    }
}




struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}




