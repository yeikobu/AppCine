//
//  MovieDetailView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 13-02-22.
//

import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var title, overview, releaseDate, imgURL: String
    var movieID: Int
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                ZStack(alignment: .topLeading) {
                    MovieInfo(title: title, overview: overview, releaseDate: releaseDate, imgURL: imgURL, movieID: movieID, isLiked: false, likeViewModel: LikeViewModel(), commentsViewModel: CommentsViewModel())
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color.white)
                            .font(.system(size: 25, weight: .bold))
                            .padding(.top, 5)
                            .padding(.leading, 10)
                            .shadow(color: .black.opacity(0.90), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.90), radius: 5, x: -5, y: -5)
                    }
                    
                    
                }
                
            }

        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


struct MovieInfo: View {
    
    @StateObject var keyboardHandler = KeyboardHandler()
    var title, overview, releaseDate, imgURL: String
    var movieID: Int?
    @State var isLiked: Bool
    @Namespace var namespace
    @ObservedObject var likeViewModel: LikeViewModel
    @ObservedObject var commentsViewModel: CommentsViewModel
    
    var body: some View {
        
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    KFImage(URL(string: imgURL))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(15)
                }
                
                HStack() {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .padding(.vertical)
                    
                    Spacer()
                    
                    if self.isLiked {
                        Image(systemName: "heart.fill")
                            .matchedGeometryEffect(id: "heart", in: namespace)
                            .foregroundColor(.red)
                            .font(.system(size: 25, design: .rounded))
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.11, blendDuration: 0.09)) {
                                    isLiked.toggle()
                                }
                            }
                    } else {
                        Image(systemName: "heart")
                            .matchedGeometryEffect(id: "heart", in: namespace)
                            .foregroundColor(.red)
                            .font(.system(size: 25, design: .rounded))
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.11, blendDuration: 0.09)) {
                                    isLiked.toggle()
                                }
                                likeViewModel.saveLikedMovie(title: title, overview: overview, releaseDate: releaseDate, isLiked: isLiked, posterPath: imgURL, movieID: movieID!)
                                
    //                            likeViewModel.compareId(movieID: movieID)
                                
                            }
                    }
                }
                .padding(.horizontal, 10)
                
                VStack {
                    
                    HStack {
                        Text("Release date: ")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        Text(releaseDate)
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    Text(overview)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                
                VStack(alignment: .leading) {

                    Text("Comments")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold, design: .rounded))

                    CommentView(movieID: movieID!)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 30)
                
            }
            .task {
                likeViewModel.checkLikedMovies(movieID: movieID!) { result in
                    if result == true {
                        isLiked = true
                    } else {
                        isLiked = false
                    }
                }
            }
        }
        .padding(.bottom, keyboardHandler.keyboardHeight)
        .ignoresSafeArea()
    }
    
    func checkIsLiked() {
        
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(title: "Red Dog", overview: "As Emily struggles to fit in at home and at school, she discovers a small red puppy who is destined to become her best friend. When Clifford magically undergoes one heck of a growth spurt, becomes a gigantic dog and attracts the attention of a genetics company, Emily and her Uncle Casey have to fight the forces of greed as they go on the run across New York City. Along the way, Clifford affects the lives of everyone around him and teaches Emily and her uncle the true meaning of acceptance and unconditional love.", releaseDate: "19-19-2222", imgURL: "https://image.tmdb.org/t/p/w500/oifhfVhUcuDjE61V5bS5dfShQrm.jpg", movieID: 634649)
    }
}
