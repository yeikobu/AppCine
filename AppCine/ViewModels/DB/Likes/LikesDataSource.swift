//
//  LikesDataSource.swift
//  AppCine
//
//  Created by Jacob Aguilar on 21-02-22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI


final class LikesDataSource {
    
    private let database = Firestore.firestore()
    private let collection = "Likes"
    private let uid = String(describing: Auth.auth().currentUser!.uid)
    private let subCollection = "likedMovies"
    
    
    func getAllLikedMovies(completionBlock: @escaping (Result<[LikesModel], Error>) -> Void) {
        
        database.collection(collection).document(uid).collection(subCollection)
            .addSnapshotListener { query, error in
                
                if let error = error {
                    print("Error: \(error)")
                    completionBlock(.failure(error))
                    return
                }
                
                guard let documents = query?.documents.compactMap({$0}) else {
                    completionBlock(.success([]))
                    return
                }
                
                let likes = documents
                                .map { try? $0.data(as: LikesModel.self) }
                                .compactMap { $0 }
                
                completionBlock(.success(likes))
            }
    }
    
    
    func saveLikedMovie(title: String, overview: String, releaseDate: String, isLiked: Bool, posterPath: String, movieID: Int, completionBlock: @escaping (Result<LikesModel, Error>) -> Void) {
        let likedMovie = LikesModel(title: title, overview: overview, releaseDate: releaseDate, isLiked: isLiked, posterPath: posterPath, movieID: movieID)
        do {
            try database.collection(collection).document(uid).collection(subCollection).document(String(movieID)).setData(from: likedMovie)
            
            completionBlock(.success(likedMovie))
        } catch {
            completionBlock(.failure(error))
        }
    }
    
    
    func checkIsLiked(movieID: Int, completionHandler: @escaping (Bool) -> Void) {
        var isMovieLiked: Bool = false
        database.collection(collection).document(uid).collection(subCollection).getDocuments() { documents, error in
            
            if error == nil {
                if documents != nil {
                    for document in documents!.documents {
                        if String(movieID) == document.documentID {
                            isMovieLiked = true
                        } 
                    }
                    completionHandler(isMovieLiked)
                }
            }
        }
    }
    
    
}
