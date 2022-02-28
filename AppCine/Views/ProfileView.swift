//
//  ProfileView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 07-02-22.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                ProfileStatsView(updateUserDataViewModel: UpdateUserDataViewModel())
            }
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ProfileStatsView: View {
    
    @ObservedObject var updateUserDataViewModel: UpdateUserDataViewModel
    @ObservedObject var signupSigninValidation = SigninSignupValidation()
    @State var likesAmount: Int = 0
    @State var commentsAmount: Int = 0
    @State var selectedProfileImage: UIImage?
    @State var profileImage: Image? = Image("avatar")
    @State var isPhotoChanged: Bool = true
    @State var isShowingConfirmation: Bool = false
    @State var isCameraActive: Bool = false
    @State var isPhotosActive: Bool = false
    @State var isEditProfileAvtive: Bool = false
    @State var userName: String = "User Name"
    @State var textAlert: String = ""
    @State var showAlert: Bool = false
    @State var editUserName: Bool = false
    @State var saveUserName: Bool = false
    @State var userImgURL: String = ""
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Profile")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                
                Spacer()
            }
            .frame(alignment: .leading)
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            
            Spacer()
            
            Button {
                updateUserDataViewModel.getImgURL()
                self.isShowingConfirmation.toggle()
            } label: {
                if isPhotoChanged == false {
                    KFImage(URL(string: userImgURL))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150, alignment: .center)
                        .cornerRadius(150)
                } else {
                    if let selectedProfileImage = selectedProfileImage {
                        Image(uiImage: selectedProfileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150, alignment: .center)
                            .cornerRadius(150)
                    } else {
                        ZStack {
                            profileImage!
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150, alignment: .center)
                                .cornerRadius(150)
                            
                            KFImage(URL(string: updateUserDataViewModel.userImageURL))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150, alignment: .center)
                                .cornerRadius(150)
                        }
                       
                    }
                }
            }
            .task {
                userImgURL = updateUserDataViewModel.userImageURL
            }
            .confirmationDialog("Choose a method to select your avatar image", isPresented: self.$isShowingConfirmation) {
                Button {
                    isCameraActive = true
                    isPhotoChanged = true
                } label: {
                    Text("Take a picture from camera")
                }
                
                
                Button {
                    isPhotosActive = true
                    isPhotoChanged = true
                } label: {
                    Text("Select an image from Photos")
                }
                
                
                Button(role: .cancel) {
                    //Do something
                } label: {
                    Text("Cancel")
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $isPhotosActive, onDismiss: {
                userImgURL = updateUserDataViewModel.userImageURL
            }) {
                ImagePicker(image: $selectedProfileImage)
                    .onDisappear {
                        updateUserDataViewModel.uploadProfileImage(image: selectedProfileImage!)
                    }
            }

            
            HStack {
                if editUserName == false {
                    Text(updateUserDataViewModel.userName)
                        .foregroundColor(.white)
                        .font(.system(size: 20,weight: .bold, design: .rounded))
                } else {
                    ZStack(alignment: .center) {
                        if signupSigninValidation.userName.isEmpty {
                            Text(userName)
                                .foregroundColor(.gray)
                                .font(.system(size: 20,weight: .bold, design: .rounded))
                                .task {
                                    userName = updateUserDataViewModel.userName
                                }
                        }
                        
                        TextField("sadfasdf", text: $signupSigninValidation.userName)
                            .foregroundColor(.white)
                            .keyboardType(.default)
                            .font(.system(size: 20,weight: .bold, design: .rounded))
                            .disableAutocorrection(true)
                    }
                    .cornerRadius(15)
                    .frame(maxWidth: 100, alignment: .center)
                }
                
                
                Button {
                    editUserName.toggle()
                    
                    if signupSigninValidation.userName.count < 6 {
                        textAlert = "Username must be at least 6 characters"
                        print(signupSigninValidation.userName.count)
                        showAlert.toggle()
                        editUserName = true
                    } else {
                        editUserName = false
                        saveUserName = true
                    }


                    if saveUserName == true {
                        updateUserDataViewModel.updateUserName(uName: signupSigninValidation.userName) { userName in
                            self.userName = userName
                        }
                    }
                } label: {
                    Image(systemName: "highlighter")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.leading, 10)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Remember!"), message: Text(textAlert), dismissButton: .cancel())
                        }
                }
                    
            }
            .padding(.horizontal, 20)
            
//            VStack(alignment: .center) {
//                //Validation form for Username
//                if !signupSigninValidation.userName.isEmpty {
//                    ValidationFormView(iconName: signupSigninValidation.isUserNameLengthValid ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.isUserNameLengthValid ? Color.green : Color.red, baseForegroundColor: Color.gray, formText: "Username must be at least 6 characters", conditionChecked: signupSigninValidation.isUserNameLengthValid)
//                        .frame(maxWidth: .infinity, alignment: .center)
//                }
//            }
//            .frame(maxWidth: .infinity, alignment: .center)
            
           
            
            
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
            Spacer()
            Spacer()
            
            SettingsView(updateUserDataViewModel: self.updateUserDataViewModel, isEditProfileAvtive: $isEditProfileAvtive)
                .task {
                    userName = updateUserDataViewModel.userName
                    userImgURL = updateUserDataViewModel.userImageURL
                    updateUserDataViewModel.getImgURL()
                }
            

            
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
    
    
    func returnUiImage(named: String) -> UIImage? {
        
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        
        return nil
    }
}


struct SettingsView: View {
    
    @ObservedObject var updateUserDataViewModel: UpdateUserDataViewModel
    @Binding var isEditProfileAvtive: Bool
    @State var isLogoutActive: Bool = false
    
    var body: some View {
        
        Spacer()
        Spacer()
        Spacer()
        
        VStack {
            VStack(spacing: 15) {
                
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
            
            Spacer()
            Spacer()
            Spacer()
            
            VStack {
                Button {
                    AuthenticationViewModel().logout()
                    isLogoutActive = true
                } label: {
                    Text("Logout")
                        .foregroundColor(.red)
                        .bold()
                }

            }
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(Color("CardColor"))
            .cornerRadius(15)
            .padding(.horizontal, 10)
            NavigationLink(isActive: $isEditProfileAvtive) {
                EditProfileView(updateUserDataViewModel: self.updateUserDataViewModel)
            } label: {
                EmptyView()
            }

            NavigationLink(isActive: $isLogoutActive) {
                SigninView(authenticationViewModel: AuthenticationViewModel())
            } label: {
                EmptyView()
            }
        }
        .padding(.top, 20)

        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
