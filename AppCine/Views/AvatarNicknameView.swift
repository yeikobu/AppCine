//
//  AvatarNicknameView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 02-02-22.
//

import SwiftUI
import Kingfisher

struct AvatarNicknameView: View {
    
    @ObservedObject var saveData: SaveData
    @ObservedObject var updateUserDataViewModel = UpdateUserDataViewModel()
    @State var isShowingConfirmation: Bool = false
    @State var selectedProfileImage: UIImage?
    @State var profileImage: Image? = Image("avatar")
    @State var isPhotoChanged: Bool = true
    @State var isCameraActive: Bool = false
    @State var isPhotosActive: Bool = false
    @State var isDashboardActive: Bool = false
    @State var userImgURL: String = ""
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Text("Hi \(saveData.returnUserData())!")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                }
                
                Text("Select a profile image")
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                
                Text("You can do it later, if you want")
                    .foregroundColor(.white)
                    .font(.system(size: 13, design: .rounded))
                
                Button {
                    self.isShowingConfirmation.toggle()
                } label: {
                    ZStack {
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
                        
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color("ButtonsColor"))
                            .font(.system(size: 35, weight: .bold, design: .rounded))
                            .offset(x: 38, y: 34)
                            .shadow(color: .black, radius: 5, x: 1, y: 1)
                            .shadow(color: .black, radius: 5, x: -1, y: -1)
                            
                    }
                    .confirmationDialog("Choose a method to select your avatar image", isPresented: self.$isShowingConfirmation) {
                        Button {
                            isCameraActive = true
                        } label: {
                            Text("Take a picture from camera")
                        }
                        
                        
                        Button {
                            isPhotosActive = true
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
                    .sheet(isPresented: $isPhotosActive) {
                        SUImagePickerView(sourceType: .savedPhotosAlbum, image: $profileImage, isPresented: $isPhotosActive)
                    }
                    .sheet(isPresented: $isCameraActive) {
                        SUImagePickerView(sourceType: .camera, image: $profileImage, isPresented: $isCameraActive)
                    }
                    
                }
                
                VStack {
                    Button {
                        updateUserDataViewModel.updateUserName(uName: saveData.userName) { userName in
                            print(updateUserDataViewModel.userName)
                        }
                        isDashboardActive = true
                    } label: {
                        Text("FINISH")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .padding()
                            .padding(.horizontal)
                    }
                    .background(Color("ButtonsColor"))
                    .cornerRadius(15)
                    .padding(.vertical, 30)
                    .shadow(color: .black, radius: 5, x: 1, y: 1)
                    .shadow(color: .black, radius: 5, x: -1, y: -1)
                }
                .padding(.top, 20)
                
                NavigationLink(isActive: $isDashboardActive) {
                    DashboardView()
                } label: {
                    EmptyView()
                }
            }
            
            

            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            if returnUiImage(named: "avatar") != nil {
                selectedProfileImage = returnUiImage(named: "avatar")!
                
            }else{
                print("Can't find a storaged image")
            }
            
        })
        
    }
        
    
    func returnUiImage(named: String) -> UIImage? {
        
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        
        return nil
    }
}


struct AvatarNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarNicknameView(saveData: SaveData())
    }
}
