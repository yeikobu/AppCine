//
//  ForgotPasswordView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 15-02-22.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var signupSigninValidation = SigninSignupValidation()
    @State var email: String = ""
    @State var isBackButtonPressed: Bool = false
    @State var isEmailAlertActive: Bool = false
    @State var messajeAlert: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.compact.down")
                        .foregroundColor(Color.white)
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                        .padding(.top, 20)
                        .shadow(color: .black.opacity(0.90), radius: 5, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.90), radius: 5, x: -5, y: -5)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Text("Reset Password")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    VStack(alignment: .center) {
                        Text("Introduce an email you have already registered")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    
                    Text("Email")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.bottom, -1)
                        .padding(.leading, 4)
                    
                    //Email field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.leading)
                        
                        ZStack(alignment: .leading) {
                            
                            if signupSigninValidation.email.isEmpty {
                                Text(verbatim: "example@example.com")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .padding(.leading, 5)
                            }
                            
                            TextField("", text: $signupSigninValidation.email)
                                .foregroundColor(.white)
                                .keyboardType(.emailAddress)
                                .font(.body)
                                .padding(15)
                                .padding(.leading, -10)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
         
                        }
                    }
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    .padding(.top, 0)
                    
                    VStack {
                        Button {
                            if signupSigninValidation.email.isEmpty {
                                messajeAlert = "You must enter an email!"
                                isEmailAlertActive = true
                            } else if signupSigninValidation.isEmailValid {
                                authenticationViewModel.recoverPass(email: email)
                                messajeAlert = "A link has been sended to your email!"
                                isEmailAlertActive = true
                            } else {
                                messajeAlert = "Email format not valid"
                                isEmailAlertActive = true
                            }
                           
                        } label: {
                            Text("Send email")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonsColor"))
                        .cornerRadius(15)
                        .padding(.vertical, 30)
                        .padding(.horizontal, 10)
                        .shadow(color: .black.opacity(0.20), radius: 5, x: 1, y: 1)
                        .shadow(color: .black.opacity(0.20), radius: 5, x: -1, y: -1)
                        .alert("\(messajeAlert)", isPresented: $isEmailAlertActive) {
                            Button("Got it!", role: .cancel) {}
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color("CardColor"))
                .cornerRadius(15)
                
                Spacer()
                
            }
            .padding(.horizontal, 10)
            NavigationLink(isActive: $isBackButtonPressed) {
                SigninView(authenticationViewModel: AuthenticationViewModel())
            } label: {
                EmptyView()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(authenticationViewModel: AuthenticationViewModel())
    }
}
