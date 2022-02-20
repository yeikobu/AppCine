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
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                ZStack(alignment: .topLeading) {
                    MovieInfo(title: title, overview: overview, releaseDate: releaseDate, imgURL: imgURL)
                    
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
    var title, overview, releaseDate, imgURL: String
    var body: some View {
        
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
                
                Image(systemName: "heart")
                    .foregroundColor(.red)
                    .font(.system(size: 25))
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
                
                CommentView()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 30)
            
        }
        .ignoresSafeArea()
        
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(title: "Red Dog", overview: "As Emily struggles to fit in at home and at school, she discovers a small red puppy who is destined to become her best friend. When Clifford magically undergoes one heck of a growth spurt, becomes a gigantic dog and attracts the attention of a genetics company, Emily and her Uncle Casey have to fight the forces of greed as they go on the run across New York City. Along the way, Clifford affects the lives of everyone around him and teaches Emily and her uncle the true meaning of acceptance and unconditional love.", releaseDate: "19-19-2222", imgURL: "https://image.tmdb.org/t/p/w500/oifhfVhUcuDjE61V5bS5dfShQrm.jpg")
    }
}
