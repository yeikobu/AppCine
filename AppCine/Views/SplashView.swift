//
//  SplashView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 31-01-22.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    @State var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                if self.isActive {
                    withAnimation(Animation.easeOut) {
                        SigninView(authenticationViewModel: AuthenticationViewModel())
                            .transition(.move(edge: .leading))
                    }
                } else {
                    LottieImage(animationName: "popcorn", loopMode: .playOnce)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
