//
//  SigninView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 31-01-22.
//

import SwiftUI
import Lottie

struct SigninView: View {
    var body: some View {
       
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                   
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 40)
                    
                    SignInAndSingUpView()
                    
                }
            }
            .navigationBarHidden(true)
        }
        
            
    }
}


struct SignInAndSingUpView: View {
    
   @State var signInType = true
    
    var body: some View {
        
        VStack {
            HStack {
                
                Spacer()
                
                Button {
                    signInType = true
                } label: {
                    Text("SIGN IN")
                        .foregroundColor(signInType ? .white : .gray)
                }
                
                Spacer()
                
                Button {
                    signInType = false
                } label: {
                    Text("SIGN UP")
                        .foregroundColor(signInType ? .gray : .white)
                }
                
                Spacer()
                
                
                
            }
            
            Spacer()
        }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
