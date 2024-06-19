import SwiftUI
import CoreData
import Foundation
import FirebaseFirestore

enum RootView {
    case login
    case signup
}

struct ContentView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    
    @State var root: RootView = .login
    @State private var selectedTab = 2 // Home screen
    
    var body: some View {
        Group {
            NavigationStack {
                if let user = firebaseAuth.user {
                    // If user is authenticated, show TabView with all tabs
                    TabView(selection: $selectedTab) {
                        NavigationView {
                            HistoryView().environmentObject(firebaseAuth)
                        }
                        .tabItem {
                            Image(systemName: "clock.arrow.circlepath")
                        }
                        .tag(0)
                        
                        NavigationView {
                            SearchView(user: user).environmentObject(firebaseAuth)
                        }
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                        }
                        .tag(1)
                        
                        NavigationView {
                            HomeView().environmentObject(firebaseAuth)
                        }
                        .tabItem {
                            Image(systemName: "house.fill")
                        }
                        .tag(2)
                        
                        NavigationView {
                            SettingsView().environmentObject(firebaseAuth)
                        }
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                        }
                        .tag(3)
                        
                        NavigationView {
                            ProfileView().environmentObject(firebaseAuth)
                        }
                        .tabItem {
                            Image(systemName: "person.fill")
                        }
                        .tag(4)
                    }
                } else {
                    // If user is not authenticated, show LoginView or SignupView
                    NavigationStack {
                        switch root {
                        case .login:
                            LoginView(root: self.$root).environmentObject(firebaseAuth)
                        case .signup:
                            SignupView(root: self.$root).environmentObject(firebaseAuth)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(FirebaseAuthHelper())
}

