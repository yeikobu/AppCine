//
//  MessageView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 19-02-22.
//

import SwiftUI
import Kingfisher

struct CommentView: View {
    
    @State var movieID: Int
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                MessageGeneralView(updateUserDataViewModel: UpdateUserDataViewModel(), movieID: movieID) //pasar a .self
            }
        }
    }
}


struct MessageGeneralView: View {
    
    @ObservedObject var commentsViewModel = CommentsViewModel()
    @ObservedObject var updateUserDataViewModel: UpdateUserDataViewModel
    let gridForm = [GridItem(.flexible())]
    @State var comment: String = ""
    @State var movieID: Int
    @State var textAlert: String = ""
    @State var isAlertActive: Bool = false
    @State var userName: String = ""
    
    var body: some View {
        VStack {
            
            HStack {
                KFImage(URL(string: updateUserDataViewModel.userImageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50, alignment: .center)
                    .cornerRadius(50)
                    .padding(.leading, 10)
                
                HStack {
                    ZStack(alignment: .leading) {
                        if comment.isEmpty {
                            Text("Write a comment about this movie")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .padding(.leading, 10)
                        }
                        
                        TextField( "", text: $comment)
                            .foregroundColor(.white)
                            .keyboardType(.emailAddress)
                            .font(.body)
                            .padding(.vertical, 15)
                            .padding(.leading, 10)
                            .disableAutocorrection(true)
                        
                    }
                }
                .background(Color("TextFieldColor"))
                .cornerRadius(15)
                .padding(.bottom, 5)
                
                Button {
                    userName = updateUserDataViewModel.userName
                    if comment.isEmpty {
                        textAlert = "The message can not be empty"
                        isAlertActive.toggle()
                        return
                    } else {
                        commentsViewModel.saveSentComment(movieID: movieID, comment: comment, userName: userName, userImgURL: updateUserDataViewModel.userImageURL)
                        comment = ""
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .padding()
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color("ButtonsColor"), Color("ButtonsSecondaryColor")]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(35)
                }
                .padding(.trailing, 10)
                .shadow(color: .black.opacity(0.20), radius: 5, x: 1, y: 1)
                .shadow(color: .black.opacity(0.20), radius: 5, x: -1, y: -1)
                .alert(isPresented: $isAlertActive) {
                    Alert(title: Text("Alert!"), message: Text(textAlert), dismissButton: .cancel(Text("Got it!")))
                }

            }
            
            Divider()
                .background(.gray)
                .cornerRadius(10)
                .padding(2)
                
            
            LazyVGrid(columns: gridForm) {
                ForEach(commentsViewModel.comments, id: \.self) { commentInfo in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    KFImage(URL(string: commentInfo.userImgURL))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .cornerRadius(50)
                                    
                                    VStack(alignment: .leading) {
                                        Text(commentInfo.userName)
                                            .foregroundColor(.white)
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                        
                                        Divider()
                                            .background(.gray)
                                    }
                                }
                                
                                Text(commentInfo.comment)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16, design: .rounded))
                            }
                        }
                        
                    }
                    .padding()
                    .background(Color("CardColor"))
                    .cornerRadius(15)
                    .padding(.horizontal, 10)
                    .padding(.top, 8)
                }
                
            }
            .task {
                commentsViewModel.getAllLikes(movieID: movieID)
            }
            
            Spacer()

        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(movieID: 634649)
    }
}
