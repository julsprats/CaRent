//
//  SettingsView.swift
//  CaRent
//
//  Created by Jasdeep Singh on 2024-06-04.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @State private var showChangeTier = false
    @State private var showCancelBooking = false
    @State private var showContactSupport = false
    @State private var showFeedback = false

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                showChangeTier = true
            }) {
                Text("Subscription Tier")
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
            .sheet(isPresented: $showChangeTier) {
                ChangeTierView().environmentObject(firebaseAuth)
            }

            Button(action: {
                showContactSupport = true
            }) {
                Text("Contact Support")
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
            .sheet(isPresented: $showContactSupport) {
                ContactSupportView()
            }

            Button(action: {
                showFeedback = true
            }) {
                Text("Provide Feedback")
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
            .sheet(isPresented: $showFeedback) {
                FeedbackView()
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView().environmentObject(FirebaseAuthHelper())
        }
    }
}
