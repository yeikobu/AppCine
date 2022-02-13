//
//  ProfileView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 07-02-22.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            ProfileStatsView()
        }
    }
}

struct ProfileStatsView: View {
    
    @State var likesAmount: Int = 0
    @State var commentsAmount: Int = 0
    @State var profileImage: UIImage = UIImage(named: "avatar")!
    var saveData = SaveData()
    @State var userName: String = "User Name"
    @State var isEditProfileAvtive: Bool = false
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Profile")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
            }
            .frame(alignment: .leading)
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            
            Spacer()
            
            Image(uiImage: profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150, alignment: .center)
                .cornerRadius(150)
            
            
            
            Text(userName)
                .foregroundColor(.white)
                .font(.system(size: 20,weight: .bold, design: .rounded))
            
            VStack(alignment: .trailing) {
             
                HStack {
                    Text("Liked movies: ")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    
                    Text("12")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .black, design: .rounded))
                }
                .padding(.top, 10)
                
                HStack {
                    Text("Comments: ")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    
                    Text("12")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .black, design: .rounded))
                }
            }
            
            Spacer()
            
            SettingsView(isEditProfileAvtive: $isEditProfileAvtive)
            
            Spacer()
            Spacer()
            
            
        }
        .onAppear {

            userName = saveData.returnUserData()  //Descomentar esta linea en produccion
            
            if returnUiImage(named: "avatar") != nil {
                profileImage = returnUiImage(named: "avatar")!
            } else {
                print("Can't find user image")
            }
        }
        
    }
    
    
    func returnUiImage(named: String) -> UIImage? {
        
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        
        return nil
    }
}


struct SettingsView: View {
    
    @Binding var isEditProfileAvtive: Bool
    
    var body: some View {
        
        VStack(spacing: 15) {
            //History
            Button {
                //
            } label: {
                HStack {
                    HStack {
                        Text("History")
                            .foregroundColor(.white)
                    }
                   
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 10)

            
            Divider()

            //EditProfile
            Button {
                isEditProfileAvtive.toggle()
            } label: {
                HStack {
                    Text("Edit Profile")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 10)
            .sheet(isPresented: $isEditProfileAvtive) {
                EditProfileView()
            }
            
            Divider()
            
            //Rate this app
            Button {
                //
            } label: {
                HStack {
                    Text("Rate this app!")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            //About this app
            Button {
                //
            } label: {
                HStack {
                    Text("About this app")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 10)

        }
        .padding(.vertical, 15)
        .background(Color("CardColor"))
        .cornerRadius(15)
        .padding(.horizontal, 10)
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
