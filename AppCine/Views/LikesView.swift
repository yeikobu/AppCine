//
//  LikesView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 07-02-22.
//

import SwiftUI
import Kingfisher

struct LikesView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                LikedMoviesGridVIew(likeViewModel: LikeViewModel())
            }
            
        }
    }
}

struct LikedMoviesGridVIew: View {
    
    @ObservedObject var likeViewModel: LikeViewModel
    let gridForm = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            Text("Liked Movies")
                .foregroundColor(.white)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: gridForm) {
                    ForEach(likeViewModel.likes, id: \.self) { like in
                        Button {
                            //
                        } label: {
                            HStack {
                                KFImage(URL(string: likeViewModel.imgUrl + like.posterPath))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
                                
                                Text(like.title)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 5)
                                
                            }
                            .background(Color("CardColor"))
                            .cornerRadius(15)
                        }

                    }
                    .listRowBackground(Color("BackgroundColor"))
                }
                .task {
                    likeViewModel.getAllLikes()
                }
            }
            .cornerRadius(15)
        }
        .padding(.horizontal, 10)
    }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView()
    }
}
