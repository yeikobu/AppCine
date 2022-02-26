//
//  LikesModel.swift
//  AppCine
//
//  Created by Jacob Aguilar on 24-02-22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct LikesModel: Decodable, Identifiable, Hashable, Encodable {
    var id: String? = Auth.auth().currentUser?.uid
    
    let title: String
    let overview: String
    let releaseDate: String
    let isLiked: Bool
    let posterPath: String
    let movieID: Int
}
