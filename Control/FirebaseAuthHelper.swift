//
//  FirebaseAuthHelper.swift
//  CaRent
//
//  Created by Julia Prats on 2024-05-23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

@MainActor
class FirebaseAuthHelper: ObservableObject {
    
    @Published var firebaseUser: FirebaseAuth.User?
    @Published var user: User?
    
    private let COLLECTION = "USERS"
    
    init() {
        self.firebaseUser = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signUp(email: String, password: String, name: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.firebaseUser = result.user
            let user = User(id: result.user.uid, name: name, email: email, subscriptionTier: "Silver", currentVehicleId: "")
            let encoded = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection(COLLECTION).document(user.id).setData(encoded)
            await fetchUser()
        } catch {
            print(#function, "Error Signing up \(error)")
            throw AUTH_ERROR.SIGNUP_ERROR
        }
    }

    func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.firebaseUser = result.user
            await fetchUser()
        } catch {
            throw AUTH_ERROR.LOGIN_ERROR
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            self.firebaseUser = nil
            self.user = nil
        } catch {
            print(#function, "Unable to logout ")
        }
    }

    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection(COLLECTION).document(uid).getDocument() else { return }
        self.user = try? snapshot.data(as: User.self)
    }
    
    enum AUTH_ERROR: Error {
        case LOGIN_ERROR, SIGNUP_ERROR, CUSTOMER_ERROR
    }
}

