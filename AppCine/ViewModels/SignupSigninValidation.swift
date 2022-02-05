//
//  SignupSigninValidation.swift
//  AppCine
//
//  Created by Jacob Aguilar on 04-02-22.
//

import Foundation
import Combine

class SigninSignupValidation: ObservableObject {
    //User inputs
    @Published var userName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    //Form validation values
    @Published var isUserNameLengthValid = false
    @Published var isEmailValid = false
    @Published var isPasswordLengthValid = false
    @Published var isPasswordCapitalLetter = false
    @Published var arePasswordsMatch = false
    
    //Error
    @Published var alert = false
    @Published var error = ""
    @Published var updateDataObject = SaveData()
    
    private var cancellableObjects: Set<AnyCancellable> = []
    
    init() {
        $userName
            .receive(on: RunLoop.main)
            .map { userName in
                return userName.count >= 6
            }
            .assign(to: \.isUserNameLengthValid, on: self)
            .store(in: &cancellableObjects)
        
        $email
            .receive(on: RunLoop.main)
            .map { email in
                if email.contains("@") {
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellableObjects)
        
        $password
            .receive(on: RunLoop.main)
            .map { password in
                return password.count >= 8
            }
            .assign(to: \.isPasswordLengthValid, on: self)
            .store(in: &cancellableObjects)
        
        $password
            .receive(on: RunLoop.main)
            .map { password in
                let pattern = "[A-Z]"
                if let _ = password.range(of: pattern, options: .regularExpression) {
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.isPasswordCapitalLetter, on: self)
            .store(in: &cancellableObjects)
        
        Publishers.CombineLatest($password, $confirmPassword)
            .receive(on: RunLoop.main)
            .map { (password, confirmPassword) in
                return !password.isEmpty && (password == confirmPassword)
            }
            .assign(to: \.arePasswordsMatch, on: self)
            .store(in: &cancellableObjects)
    }
    
}
