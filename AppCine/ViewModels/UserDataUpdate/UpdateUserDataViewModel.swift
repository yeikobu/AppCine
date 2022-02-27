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
import UIKit

final class UpdateUserDataViewModel: ObservableObject {
    
    @Published var userName: String = ""
    private var changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    let currentUserUID = Auth.auth().currentUser?.uid
    @Published var userEmail: String = "example@example.com"
    @Published var userImageURL: String = ""
    
    
    
    init() {
        userName = Auth.auth().currentUser?.displayName ?? "User Name"
        
        userImageURL = "https://firebasestorage.googleapis.com:443/v0/b/appcineios.appspot.com/o/\(String(describing: currentUserUID))?alt=media&token=2d16e6f7-fd97-4bd7-8d90-8a9f224ed8ac"
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
    
    func uploadProfileImage(image: UIImage?) {
//        let localFile = URL(string: "avatar.jpg")
        let reference = Storage.storage().reference(withPath: self.currentUserUID!)
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        reference.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
            }
            
            reference.downloadURL { url, error in
                if let error = error {
                    print(error)
                    return
                }
                print(url?.absoluteString ?? "")
                
                if let imageURL = url {
                    self.userImageURL = imageURL.absoluteString
                }
            }
        }
        
        print(self.userImageURL)
    }
    
    
//    func downloadImage() {
//        let spaceRef = self.storageReference.child("images/\(String(describing: currentUserUID))/avatar.jpg")
//
//        let localURL = URL(string: "avatar.jpg")
//
//        let downloadTask = spaceRef.write(toFile: localURL!) { url, error in
//          if let error = error {
//            print(error)
//          } else {
//            print(url ?? "hola")
//          }
//        }
//
//        downloadTask.resume()
//    }
    
}
