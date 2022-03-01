//
//  SaveLocalData.swift
//  AppCine
//
//  Created by Jacob Aguilar on 03-02-22.
//

import Foundation
import SwiftUI

class SaveData: ObservableObject {
    
    @Published var userName: String = ""
    
    func saveData(name: String)  {
        print("Got information in saveData: \(name)")
        
        UserDefaults.standard.set([name], forKey: "userDatas")
        
    }
    
    func receibeData() -> [String] {
        let userData: [String] = UserDefaults.standard.stringArray(forKey: "userDatas")!
        
        print("info in receibeData \(userData)")
        
        return userData
    }
    
    func validateInit() -> Bool{
        if let _: [String] = UserDefaults.standard.stringArray(forKey: "userDatas") {
           return true
        } else {
           return false
        }
    }
    
    func validate(email: String, pass: String) -> Bool {
        
        if (email == UserDefaults.standard.stringArray(forKey: "userDatas")![0] && pass == UserDefaults.standard.stringArray(forKey: "userDatas")![1]) {
            print("Entra aqui")
            return true
        } else {
            return false
        }
    }
    
    func signUp(email: String, pass: String, username: String) {
        print("Dentro de la funcion signUp obtubimos: \(email) + \(pass) + \(username)")
        UserDefaults.standard.set([email, pass, username], forKey: "userDatas")
        
        print("UserDefaults Posi 0: \(UserDefaults.standard.stringArray(forKey: "userDatas")![0])")
        print("UserDefaults Posi 1: \(UserDefaults.standard.stringArray(forKey: "userDatas")![1])")
        
    }
    
    func returnUserData() -> String {
        var name: [String] = []
        if let userNameUserDefaults: [String] = UserDefaults.standard.stringArray(forKey: "userDatas") {
            name = userNameUserDefaults
        }
        UpdateUserDataViewModel().updateUserName(uName: name[0]) { user in
            //
        }
        return name[0]
    }
    
}
