//
//  LikesViewModel.swift
//  AppCine
//
//  Created by Jacob Aguilar on 21-02-22.
//

import Foundation

final class LikeViewModel: ObservableObject {
    @Published var likes: [LikesModel] = []
    @Published var messageError: String?
    @Published var imgUrl: String = "https://image.tmdb.org/t/p/w500"
    private let likeRepository: LikesRepository
    
    
    init(likeRepository: LikesRepository = LikesRepository()) {
        self.likeRepository = likeRepository
    }
    
    
    func getAllLikes() {
        likeRepository.getAllLikes { [weak self] result in
            switch result {
            case .success(let likeModels):
                self?.likes = likeModels
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    
    func saveLikedMovie(title: String, overview: String, releaseDate: String, isLiked: Bool, posterPath: String, movieID: Int) {
        likeRepository.saveLikedMovie(title: title, overview: overview, releaseDate: releaseDate, isLiked: isLiked, posterPath: posterPath, movieID: movieID) { result in
            switch result {
            case .success( _):
                print("Movie liked")
            case .failure(let error):
                self.messageError = error.localizedDescription
            }
        }
    }
    
    
    func checkLikedMovies(movieID: Int, completionHandler: @escaping (Bool) -> Void) {
        likeRepository.checkLikedMovies(movieID: movieID) { result in
            completionHandler(result)
        }
    }
    
}
