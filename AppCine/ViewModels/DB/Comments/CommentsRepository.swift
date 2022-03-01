//
//  CommentsRepository.swift
//  AppCine
//
//  Created by Jacob Aguilar on 28-02-22.
//

import Foundation

final class CommentsRepository {
    private let commentsDataSource: CommentsDataSource
    
    init(commentsDataSource: CommentsDataSource = CommentsDataSource()) {
        self.commentsDataSource = commentsDataSource
    }
    
    func getAllComments(movieID: Int, completionBlock: @escaping (Result<[UserCommentModel], Error>) -> Void) {
        self.commentsDataSource.getAllComments(movieID: movieID, completionBlock: completionBlock)
    }
    
    func saveSentComment(movieID: Int, comment: String, userName: String, userImgURL: String, completionBlock: @escaping (Result<UserCommentModel, Error>) -> Void) {
        self.commentsDataSource.saveSentComment(movieID: movieID, comment: comment, userName: userName, userImgURL: userImgURL) { [weak self] result in
            
            switch result {
            case .success(let commentModel):
                self?.commentsDataSource.saveSentComment(movieID: commentModel.movieID, comment: commentModel.comment, userName: commentModel.userName, userImgURL: commentModel.userImgURL, completionBlock: completionBlock)
            case .failure(let error):
                completionBlock(.failure(error))
            }
            
        }
    }
}
