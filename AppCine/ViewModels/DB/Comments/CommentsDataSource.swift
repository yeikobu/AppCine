//
//  CommentsDataSource.swift
//  AppCine
//
//  Created by Jacob Aguilar on 28-02-22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


final class CommentsDataSource {
    
    private let database = Firestore.firestore()
    private let collection = "Comments"
    private let usersCommentsCollection = "usersComments"
    private let userID = String(describing: Auth.auth().currentUser!.uid)
    @Published var userName: String? = Auth.auth().currentUser!.displayName
    
    
    func getAllComments(movieID: Int, completionBlock: @escaping (Result<[UserCommentModel], Error>) -> Void) {
        
        database.collection(collection).document(String(movieID)).collection(usersCommentsCollection).addSnapshotListener { query, error in
            
            if let error = error {
                print("ERROR: \(error)")
                completionBlock(.failure(error))
                return
            }
            
            guard let documents = query?.documents.compactMap({$0}) else {
                completionBlock(.success([]))
                return
            }
            
            let comments = documents
                            .map { try? $0.data(as: UserCommentModel.self) }
                            .compactMap { $0 }
            
            completionBlock(.success(comments))
        }
    }
    
    
    func saveSentComment(movieID: Int, comment: String, userName: String, userImgURL: String, completionBlock: @escaping (Result<UserCommentModel, Error>) -> Void) {
        
        let userComment = UserCommentModel(comment: comment, userImgURL: userImgURL, userName: userName, movieID: movieID)
        
        do {
            try
            database.collection(collection).document(String(movieID)).collection(usersCommentsCollection).document().setData(from: userComment)
            completionBlock(.success(userComment))
        } catch {
            completionBlock(.failure(error))
        }
    }
}
