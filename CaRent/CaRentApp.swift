//
//  CaRentApp.swift
//  CaRent
//
//  Created by Julia Prats on 2024-05-23.
//

import SwiftUI
import Firebase

@main
struct YourAppNameApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FirebaseAuthHelper()) // Make sure to inject your FirebaseAuthHelper
        }
    }
}
