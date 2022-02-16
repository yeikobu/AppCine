//
//  EditProfileView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 07-02-22.
//

import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var isBackButtonActive: Bool = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .center) {
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.compact.down")
                            .foregroundColor(Color.white)
                            .font(.system(size: 35, weight: .bold))
                            .padding(.top, 5)
                            .shadow(color: .black.opacity(0.90), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.90), radius: 5, x: -5, y: -5)
                    }
                   
                }
                .padding(.top)
                
                Spacer()
                
                UserImageModuleView()
                
                Spacer()
            }
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


struct UserImageModuleView: View {
    
    @State var selectedProfileImage: UIImage = UIImage(named: "avatar")!
    @State var profileImage: Image? = Image("avatar")
    @State var isCameraActive: Bool = false
    @State var isPhotosActive: Bool = false
    @State var isShowingConfirmation: Bool = false
    @State var isPhotoChanged: Bool = true
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack {
                ZStack {
                    Button {
                        self.isShowingConfirmation.toggle()
                    } label: {
                        ZStack {
                            
                            if isPhotoChanged == false {
                                profileImage!
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .cornerRadius(150)
                            } else {
                                Image(uiImage: selectedProfileImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .cornerRadius(150)
                            }
                           
                            
                            Text("Edit")
                                .foregroundColor(Color(.white))
                                .bold()
                                .padding(5)
                                .frame(width: 150)
                                .background(Color("ButtonsColor"))
                                .cornerRadius(20)
                                .offset(x: 0, y: 66)
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
                        .sheet(isPresented: $isPhotosActive) {
                            SUImagePickerView(sourceType: .savedPhotosAlbum, image: $profileImage, isPresented: $isPhotosActive)
                        }
                        .sheet(isPresented: $isCameraActive) {
                            SUImagePickerView(sourceType: .camera, image: $profileImage, isPresented: $isCameraActive)
                        }
                        
                    }
                    .cornerRadius(150)
                    
                    
                    Button {
                        self.isShowingConfirmation.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color("ButtonsColor"))
                            .font(.system(size: 35, weight: .bold))
                            .offset(x: 48, y: 48)
                            .shadow(color: .black, radius: 5, x: 1, y: 1)
                            .shadow(color: .black, radius: 5, x: -1, y: -1)
                    }
                   
                }
                
                EditFieldsModuleView()
            }
        }
        .padding(.top, 30)
        .onAppear(perform: {
            if returnUiImage(named: "avatar") != nil {
                selectedProfileImage = returnUiImage(named: "avatar")!
                
            }else{
                profileImage = Image("avatar")
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


struct EditFieldsModuleView: View {
    
    @ObservedObject var signupSigninValidation = SigninSignupValidation()
    @State var isSecure: Bool = true
    @State var areFieldsIncomplete: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                
                //Username field
                Text("Username")
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top, 20)
                    .padding(.bottom, -1)
                    .padding(.leading, 4)
                
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(.leading)
                    
                    ZStack(alignment: .leading) {
                        if signupSigninValidation.userName.isEmpty {
                            Text("Write your username/nickname")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .padding(.leading, 5)
                        }
                        
                        TextField("", text: $signupSigninValidation.userName)
                            .foregroundColor(.white)
                            .keyboardType(.default)
                            .font(.body)
                            .padding(15)
                            .padding(.leading, -10)
                            .disableAutocorrection(true)
                    }
                }
                .background(Color("TextFieldColor"))
                .cornerRadius(15)
                .padding(.top, 0)
                
                //Validation form for Username
                if !signupSigninValidation.userName.isEmpty {
                    ValidationFormView(iconName: signupSigninValidation.isUserNameLengthValid ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.isUserNameLengthValid ? Color.green : Color.red, baseForegroundColor: Color.gray, formText: "Username must be at least 6 characters", conditionChecked: signupSigninValidation.isUserNameLengthValid)
                        .transition(.slide)
                }
                
                
                //Email field
                Text("Email")
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top, 10)
                    .padding(.bottom, -1)
                    .padding(.leading, 4)
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(.leading)
                    
                    ZStack(alignment: .leading) {
                        
                        if signupSigninValidation.email.isEmpty {
                            Text(verbatim: "example@example.com")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .padding(.leading, 5)
                        }
                        
                        TextField("", text: $signupSigninValidation.email)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.white)
                            .font(.body)
                            .padding(15)
                            .padding(.leading, -10)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
     
                    }
                }
                .background(Color("TextFieldColor"))
                .cornerRadius(15)
                .padding(.top, 0)
                
                //Validation form for Email
                if !signupSigninValidation.email.isEmpty {
                    ValidationFormView(iconName: signupSigninValidation.isEmailValid ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.isEmailValid ? Color.green : Color.red, baseForegroundColor: Color.gray, formText: "Write a valid email", conditionChecked: signupSigninValidation.isEmailValid)
                }
                
                
                VStack(alignment: .leading) {
                    //Password field
                    Text("Password")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.top, 10)
                        .padding(.bottom, -0.5)
                        .padding(.leading, 4)
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .padding(.leading)
                        
                        ZStack(alignment: .leading) {
                            
                            if signupSigninValidation.password.isEmpty {
                                Text("Chose your password")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .padding(.leading, 5)
                            }
                            
                            if isSecure {
                                SecureField("", text: $signupSigninValidation.password)
                                    .foregroundColor(.white)
                                    .keyboardType(.default)
                                    .font(.body)
                                    .padding(15)
                                    .padding(.leading, -10)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                            } else {
                                TextField("", text: $signupSigninValidation.password)
                                    .foregroundColor(.white)
                                    .keyboardType(.default)
                                    .font(.body)
                                    .padding(15)
                                    .padding(.leading, -5)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                            }
                        }
                        
                        Button {
                            withAnimation(Animation.default) {
                                isSecure.toggle()
                            }
                        } label: {
                            isSecure ?
                            Image(systemName: "eye")
                                .foregroundColor(Color("ButtonsColor"))
                                .padding(.trailing) :
                            Image(systemName: "eye.slash")
                                .foregroundColor(Color(.red))
                                .padding(.trailing)
                        }

                    }
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    
                    //Password form validations
                    VStack {
                        if !signupSigninValidation.password.isEmpty {
                            ValidationFormView(iconName: signupSigninValidation.isPasswordLengthValid ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.isPasswordLengthValid ? Color.green : Color.red, baseForegroundColor: Color.gray, formText: "Must contain at least 8 characters", conditionChecked: signupSigninValidation.isPasswordLengthValid)
                            
                            ValidationFormView(iconName: signupSigninValidation.isPasswordCapitalLetter ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.isPasswordCapitalLetter ? Color.green : Color.red, baseForegroundColor: Color.gray, formText: "Must cointain at leas one capital letter", conditionChecked: signupSigninValidation.isPasswordCapitalLetter)
                        }
                    }
                    
                    
                    //COnfirm Button
                    Button {
                        //
                    } label: {
                        Text("SAVE DATA")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("ButtonsColor"))
                    .cornerRadius(15)
                    .padding(.vertical, 30)
                    .padding(.horizontal, 10)
                    .shadow(color: .black.opacity(0.20), radius: 5, x: 1, y: 1)
                    .shadow(color: .black.opacity(0.20), radius: 5, x: -1, y: -1)
                    .alert(isPresented: $areFieldsIncomplete) {
                        Alert(title: Text("ERROR"), message: Text("All fields are requiere"), dismissButton: .default(Text("Okay")))
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .background(Color("CardColor"))
        .cornerRadius(15)
        .padding(.top, 20)
        .padding(.horizontal, 10)
        .frame(maxHeight: .infinity)
    }
}


struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
