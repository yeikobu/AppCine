//
//  UpdateUserData.swift
//  AppCine
//
//  Created by Jacob Aguilar on 24-02-22.
//

import Foundation
import FirebaseAuth
import Accelerate
import Firebase
import FirebaseStorage

final class UpdateUserDataViewModel: ObservableObject {
    
    @Published var userName: String = ""
    private var changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    @Published var userEmail: String = "example@example.com"
    let storageReference = Storage.storage().reference()
    let currentUserUID = Auth.auth().currentUser!.uid
    
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
    
    func uploadProfileImage() {
        let localFile = URL(string: "avatar.jpg")
        let spaceRef = self.storageReference.child("images/\(String(describing: currentUserUID))/avatar.jpg")
        
        let uploadTask = spaceRef.putFile(from: localFile!, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                print("An herros ocurred")
                return
            }
            
            let size = metadata.size
            
            spaceRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
            }
        }
        uploadTask.resume()
    }
    
    
    func downloadImage() {
        let spaceRef = self.storageReference.child("images/\(String(describing: currentUserUID))/avatar.jpg")
        
        let localURL = URL(string: "avatar.jpg")
        
        let downloadTask = spaceRef.write(toFile: localURL!) { url, error in
          if let error = error {
            print(error)
          } else {
            print(url ?? "hola")
          }
        }
        
        downloadTask.resume()
    }
    
}
