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

struct LikesModel: Decodable, Identifiable, Hashable {
    var id: String? = Auth.auth().currentUser?.uid

    let title: String
    let overview: String
    let releaseDate: String
    let isLiked: Bool
    let posterPath: String
}

final class LikesDataSource {
    private let database = Firestore.firestore()
    private let collection = "Likes"
    private let uid = String(describing: Auth.auth().currentUser!.uid)
    private let subCollection = "likedMovies"
    
    func getAllLikedMovies(completionBlock: @escaping (Result<[LikesModel], Error>) -> Void) {
        print("uid: \(uid)")
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
                
                let likes = documents.map { try? $0.data(as: LikesModel.self) }
                                    .compactMap { $0 }
                
                print("likes: \(likes)")
                
                completionBlock(.success(likes))
            }
    }
}
