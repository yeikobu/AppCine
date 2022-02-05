//
//  AvatarNicknameView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 02-02-22.
//

import SwiftUI

struct AvatarNicknameView: View {
    
    @State var isShowingConfirmation: Bool = false
    @State var isCameraActive: Bool = false
    @State var isPhotosActive: Bool = false
    @State var selectedProfileImage: UIImage = UIImage(named: "avatar")!
    @State var profileImage: Image? = Image("avatar")
    @State var isDashboardActive: Bool = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                Text("Select a profile image")
                    .foregroundColor(.white)
                    .bold()
                
                Button {
                    self.isShowingConfirmation.toggle()
                } label: {
                    ZStack {
                        profileImage!
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .cornerRadius(60)
                        
                        Image(systemName: "camera")
                            .foregroundColor(Color(.white))
                            .font(.system(size: 26, weight: .bold))
                            .offset(x: 40, y: 40)
                            
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
        AvatarNicknameView()
    }
}
