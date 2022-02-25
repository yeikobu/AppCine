//
//  UpdateUserData.swift
//  AppCine
//
//  Created by Jacob Aguilar on 24-02-22.
//

import Foundation
import FirebaseAuth
import Accelerate

final class UpdateUserDataViewModel: ObservableObject {
    
    @Published var userName: String = ""
    private var changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    @Published var userEmail: String = "example@example.com"
    
    init() {
        userName = Auth.auth().currentUser?.displayName ?? "User Name"
    }
    
    func getCurrentUserName() {
        userName = Auth.auth().currentUser?.displayName ?? "User Name"
        print("Current user name: \(userName)")
    }
    
    func updateUserName(uName: String, completionHandler: @escaping (String) -> Void) {
        changeRequest?.displayName = uName
        changeRequest?.commitChanges(completion: { error in
            if error == nil {
                self.userName = uName
                completionHandler(self.userName)
            }
            
        })
        
    }
}
