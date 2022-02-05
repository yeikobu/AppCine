//
//  DashboardView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 02-02-22.
//

import SwiftUI

struct DashboardView: View {
    
    @State var backToLogin = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
