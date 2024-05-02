//
//  LoginSuccess.swift
//  LoginTestApp
//
//  Created by Федор Шашков on 30.04.2024.
//

import SwiftUI

struct LoginSuccess: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = LoginSuccessViewModel()
    
    var body: some View {
        VStack {
            Text("Успешный вход в приложение")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                viewModel.signOut() {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Выход из аккаунта")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
}


struct LoginSuccess_Previews: PreviewProvider {
    static var previews: some View {
        LoginSuccess()
    }
}
