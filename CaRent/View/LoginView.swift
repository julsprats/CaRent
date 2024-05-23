//
//  LoginView.swift
//  CaRent
//
//  Created by Julia Prats on 2024-05-23.
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @Binding var root: RootView
    
    @AppStorage("KEY_USER") private var usernameFromUi: String = ""
    @AppStorage("KEY_PASSWORD") private var passwordFromUi: String = ""
    @AppStorage("KEY_REMEMBER") private var rememberUserAndPassword = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                Image("logo")
                    .resizable()
                    .frame(width: 150.0, height: 150.0)
                
                HStack {
                    Text("Welcome to")
                        .font(.system(size: 32))
                        .fontWeight(.bold)
                    
                    Text("CaRent")
                        .font(.system(size: 32))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                }
                .padding(.bottom, 40.0)
            }
            VStack {
                Form {
                    Section {
                        HStack {
                            TextField("Enter Email", text: $usernameFromUi)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                            Image(systemName: "person.fill")
                        }
                        HStack {
                            SecureField("Enter Password", text: $passwordFromUi)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                            Image(systemName: "key.horizontal.fill")
                        }
                    } header: { Text("Log In") }
                    
                    Section {
                        Toggle("Remember Me", isOn: $rememberUserAndPassword)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 208/255, green: 152/255, blue: 0/255)))
                    }
                    
                    Section {
                        Button {
                            if !usernameFromUi.isEmpty && !passwordFromUi.isEmpty {
                                Task {
                                    do {
                                        try await firebaseAuth.signIn(email: usernameFromUi, password: passwordFromUi)
                                        if !rememberUserAndPassword {
                                            clearLogin()
                                        }
                                    } catch {
                                        showError = true
                                        errorMessage = "Unable To Login"
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("Log In")
                                Spacer()
                            }
                        }
                        .alert(isPresented: $showError) {
                            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Dismiss")))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold)
                        .cornerRadius(8)
                        
                        
                        Button {
                            self.root = .signup
                        } label: {
                            HStack {
                                Spacer()
                                Text("Create Account")
                                    .foregroundColor(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                                Spacer()
                            }
                        }
                    }
                }
                .frame(maxHeight: 400)
            }
        }
    }
    
    private func clearLogin() {
        self.usernameFromUi = ""
        self.passwordFromUi = ""
        self.rememberUserAndPassword = false
        print("User Cleared")
    }
}
