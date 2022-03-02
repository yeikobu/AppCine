//
//  CommentsViewModel.swift
//  AppCine
//
//  Created by Jacob Aguilar on 28-02-22.
//

import Foundation

final class CommentsViewModel: ObservableObject {
    @Published var comments: [UserCommentModel] = []
    @Published var messageError: String?
    private let commentsRepository: CommentsRepository
    
    init(commentsRepository: CommentsRepository = CommentsRepository()) {
        self.commentsRepository = commentsRepository
    }
    
    func getAllComments(movieID: Int) {
        commentsRepository.getAllComments(movieID: movieID) { [weak self] result in
            switch result {
            case .success(let commentsModels):
                self?.comments = commentsModels
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    
    func saveSentComment(movieID: Int, comment: String, userName: String, userImgURL: String) {
        commentsRepository.saveSentComment(movieID: movieID, comment: comment, userName: userName, userImgURL: userImgURL) { result in
            switch result {
            case .success( _):
                print("Message sent")
            case .failure(let error):
                self.messageError = error.localizedDescription
            }
        }
    }
}
