//
//  LikesRepository.swift
//  AppCine
//
//  Created by Jacob Aguilar on 21-02-22.
//

import Foundation

final class LikesRepository {
    private let likesDataSourse: LikesDataSource
    
    init(likesDataSourse: LikesDataSource = LikesDataSource()) {
        self.likesDataSourse = likesDataSourse
    }
    
    func getAllLikes(completionBLock: @escaping (Result<[LikesModel], Error>) -> Void) {
        self.likesDataSourse.getAllLikedMovies(completionBlock: completionBLock)
    }
}
