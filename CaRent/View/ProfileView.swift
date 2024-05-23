//
//  ProfileView.swift
//  CaRent
//
//  Created by Julia Prats on 2024-05-23.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @State private var showAlert = false
    @State private var showEditProfile = false
    @State private var newProfilePicture: UIImage? = nil
    @State private var showImagePicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Display user information
            if let user = firebaseAuth.user {
                VStack {
                    // Profile picture
                    if let newProfilePicture = newProfilePicture {
                        Image(uiImage: newProfilePicture)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image("profile_picture")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Change Profile Picture")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 208/255, green: 152/255, blue: 0/255))
                            .padding(.bottom, 20)
                    }
                    .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                        ImagePicker(image: $newProfilePicture)
                    }
                    
                    Text("Name: \(user.name)")
                        .font(.title2)
                    Text("Email: \(user.email)")
                        .font(.subheadline)
                    Text("Subscription Tier: \(user.subscriptionTier)")
                        .font(.subheadline)
                    Text("Current Vehicle ID: \(user.currentVehicleId)")
                        .font(.subheadline)
                }
                
                Spacer()
                
                // Edit Profile Button
                Button(action: {
                    showEditProfile = true
                }) {
                    Text("Edit Profile")
                        .font(.headline)
                        .foregroundColor(Color.black) // Color for the text
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white) // Background color
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 208/255, green: 152/255, blue: 0/255), lineWidth: 2) // Gold border
                        )
                }
                .sheet(isPresented: $showEditProfile) {
                    EditProfileView(user: user)
                }
                
                // Log Out Button
                Button(action: {
                    showAlert = true
                }) {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold background
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Log Out"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("Log Out")) {
                            firebaseAuth.logout()
                        },
                        secondaryButton: .cancel()
                    )
                }
            } else {
                Text("Loading user data...")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .navigationBarTitle("Profile", displayMode: .inline)
    }
    
    private func loadImage() {
        // Implement logic to load and update the profile picture
    }
}

#Preview {
    ProfileView().environmentObject(FirebaseAuthHelper())
}

struct EditProfileView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String
    @State private var email: String
    @State private var user: User

    init(user: User) {
        _name = State(initialValue: user.name)
        _email = State(initialValue: user.email)
        _user = State(initialValue: user)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Name:")
                    .padding(.leading) // Align to the left
                Spacer() // Push the TextField to the right
            }
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            HStack {
                Text("Email:")
                    .padding(.leading) // Align to the left
                Spacer() // Push the TextField to the right
            }
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                // Update the user object with new values
                user.name = name
                user.email = email
                
                // Update Firestore
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Changes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 208/255, green: 152/255, blue: 0/255))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.top, 40)
        .navigationBarTitle("Edit Profile", displayMode: .inline)
    }
}



#Preview {
    EditProfileView(user: User(id: "1", name: "John Doe", email: "johndoe@example.com", subscriptionTier: "Gold", currentVehicleId: "123")).environmentObject(FirebaseAuthHelper())
}

// View for picking images from the photo library
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
