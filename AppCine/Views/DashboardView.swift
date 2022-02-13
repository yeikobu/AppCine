//
//  DashboardView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 02-02-22.
//

import SwiftUI

let tabs = ["person", "house", "heart"]

struct DashboardView: View {
    
    @State var backToLogin = false
    @State var selectedTab = 1
    
    var body: some View {
        
        CustomTabView()
            .accentColor(.white)
            .transition(.slide)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        
    }
    
}

struct TabButtonview: View {
    
    @Binding var selectedTab: String
    var imageName: String
    
    var body: some View {
        Button {
            selectedTab = imageName
        } label: {
            Image(systemName: imageName)
                .foregroundColor(selectedTab == imageName ? Color("ButtonsColor") : Color(.gray))
                .font(.system(size: 24, weight: .bold))
                .padding()
        }

    }
}


struct CustomTabView: View {
    
    @State var selectedTab: String = "house"
    @State var edge: CGFloat = 0.0
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                
                ProfileView()
                    .tag("person")
                
                HomeView()
                    .tag("house")
                
                LikesView()
                    .tag("heart")
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all, edges: .bottom)
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { imageName in
                    TabButtonview(selectedTab: $selectedTab, imageName: imageName)
                    
                    if imageName != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 3)
            .background(Color("TextFieldColor"))
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.70), radius: 5, x: 5, y: 5)
            .shadow(color: .black.opacity(0.70), radius: 5, x: -5, y: -5)
            .padding(.horizontal, 10)
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.white.opacity(0.20).ignoresSafeArea(.all, edges: .all))
        
    }
    
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
