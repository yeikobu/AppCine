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
    
    
    func saveLikedMovie(title: String, overview: String, releaseDate: String, isLiked: Bool, posterPath: String, movieID: Int, completionBlock: @escaping (Result<LikesModel, Error>) -> Void) {
        self.likesDataSourse.saveLikedMovie(title: title, overview: overview, releaseDate: releaseDate, isLiked: isLiked, posterPath: posterPath, movieID: movieID) { [weak self] result in
            switch result {
            case .success(let likeModel):
                self?.likesDataSourse.saveLikedMovie(title: likeModel.title, overview: likeModel.overview, releaseDate: likeModel.releaseDate, isLiked: likeModel.isLiked, posterPath: likeModel.posterPath, movieID: movieID, completionBlock: completionBlock)
            case .failure(let error):
                completionBlock(.failure(error))
            }
        }
    }
    
    
    func checkLikedMovies(movieID: Int, completionHandler: @escaping (Bool) -> Void) {
        self.likesDataSourse.checkIsLiked(movieID: movieID) { result in
           completionHandler(result)
        }
    }
    
}
