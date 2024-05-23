//
//  SignUpView.swift
//  CaRent
//
//  Created by Julia Prats on 2024-05-23.
//

import Foundation
import SwiftUI

struct SignupView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @Binding var root: RootView
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var showError = false
    @State private var errorMsg = ""
    
    var body: some View {
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
                    .foregroundColor(Color(red: 208/255, green: 152/255, blue: 0/255))
            }
            .padding(.bottom, 40.0)
        }
        VStack {
            Form {
                Section {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                Section {
                    TextField("Name", text: $name)
                }
                
                Section {
                    Button {
                        Task {
                            do {
                                try await firebaseAuth.signUp(email: email, password: password, name: name)
                                self.root = .login
                            } catch {
                                showError = true
                                errorMsg = "Unable to Create Account"
                            }
                        }
                    } label: {
                        Text("Create")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold)
                    .cornerRadius(8)
                    .padding()
                }
            }
            .frame(maxHeight: 400)
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.root = .login
                    } label: {
                        Text("Login")
                            .foregroundColor(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                    }
                }
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMsg),
                    dismissButton: .default(Text("Dismiss"))
                )
            }
        }
    }
}
