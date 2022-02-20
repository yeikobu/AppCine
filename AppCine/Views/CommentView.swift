//
//  MessageView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 19-02-22.
//

import SwiftUI

struct CommentView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                MessageGeneralView()
            }
        }
    }
}


struct MessageGeneralView: View {
    
    @State var comment: String = ""
    
    var body: some View {
        VStack {
            
            HStack {
                Image("avatar")
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
                    //
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

            }
            
            Divider()
                .background(.gray)
                .cornerRadius(10)
                .padding(2)
                
            SendedMessageView(userName: "Jacob", userComment: "Here the user comment will displays. And this view can expands to infinithy height if is neccesary.")
            
            SendedMessageView(userName: "Luis", userComment: "Here the user comment will displays. And this view can expands to infinithy height if is neccesary.")
            
            Spacer()

        }
    }
}

struct SendedMessageView: View {
    
    var userName: String
    var userComment: String
    
    var body: some View {
        
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image("avatar")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50, alignment: .center)
                        
                        VStack(alignment: .leading) {
                            Text(userName)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                            
                            Divider()
                                .background(.gray)
                        }
                    }
                    
                    Text(userComment)
                        .foregroundColor(.gray)
                        .font(.system(size: 14, design: .rounded))
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


struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
