//
//  UserCommentModel.swift
//  AppCine
//
//  Created by Jacob Aguilar on 28-02-22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct UserCommentModel: Decodable, Identifiable, Hashable, Encodable {
    var id: String? = Auth.auth().currentUser!.uid
    let comment: String
    let userImgURL: String
    let userName: String
    let movieID: Int
}
