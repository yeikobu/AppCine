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
    
    @Published var userName: String = Auth.auth().currentUser?.displayName ?? "User Name"
    private var changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    let currentUserUID = Auth.auth().currentUser?.uid
    @Published var userEmail: String = "example@example.com"
    @Published var userImageURL: String = ""
    
    
    
    init() {
        userName = Auth.auth().currentUser?.displayName ?? "User Name"
        
        getImgURL()
//        userImageURL = "https://firebasestorage.googleapis.com:443/v0/b/appcineios.appspot.com/o/images%2F\(String(describing: currentUserUID))%2Favatar.jpg?alt=media&token=8038369d-b8b8-412c-a1f4-c90abd344671"
        
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
    
    
    func uploadProfileImage(image: UIImage) {
        var imgurl: String = ""
        let reference = Storage.storage().reference(withPath: "images/\(String(describing: self.currentUserUID))/avatar.jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        reference.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
            }
            
            reference.downloadURL { url, error in
                if let error = error {
                    print(error)
                    return
                }
                
                if let imageURL = url {
                    imgurl = imageURL.absoluteString
                    self.userImageURL = imgurl
                }
            }
        }
    }
    
    
    func getImgURL() {
        var imgurl: String = ""
        let reference = Storage.storage().reference(withPath: "images/\(self.currentUserUID)/avatar.jpg")
        
        reference.downloadURL { url, error in
            if let error = error {
                print(error)
                return
            }
            
            if let imageURL = url {
                imgurl = imageURL.absoluteString
                self.userImageURL = imgurl
            }
        }
    }
    
}
