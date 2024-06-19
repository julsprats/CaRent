//
//  ChangeTierView.swift
//  CaRent
//
//  Created by Jasdeep Singh on 2024-06-04.
//

import SwiftUI
import FirebaseFirestore

struct ChangeTierView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @State private var selectedTier: String = "Silver"
    @State private var showTierDetail = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Text("Actual Subscription Tier:")
                    .bold()
                
                if let user = firebaseAuth.user {
                    VStack {
                        Image(tierImageName(for: user.subscriptionTier))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                        Text(user.subscriptionTier)
                            .font(.title)
                    }
                    
                    Text(benefits(for: user.subscriptionTier))
                    
                    Text("Explore other tiers:")
                        .bold()
                    
                    HStack(spacing: 20) {
                        if user.subscriptionTier != "Gold" {
                            NavigationLink(destination: TierDetailView(tier: "Gold")) {
                                VStack {
                                    Image("GoldTier")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                    Text("Gold")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                        }
                        
                        if user.subscriptionTier != "Platinum" {
                            NavigationLink(destination: TierDetailView(tier: "Platinum")) {
                                VStack {
                                    Image("PlatinumTier")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                    Text("Platinum")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                        }
                        
                        if user.subscriptionTier != "Silver" {
                            NavigationLink(destination: TierDetailView(tier: "Silver")) {
                                VStack {
                                    Image("SilverTier")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                    Text("Silver")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                        }
                    }
                    
                    Button(action: {
                        selectedTier = "Unsubscribed"
                        updateSubscriptionTier()
                    }) {
                        Text("Unsubscribe")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .onAppear {
                if let user = firebaseAuth.user {
                    selectedTier = user.subscriptionTier
                }
            }
            .navigationBarTitle("Subscription Tier", displayMode: .inline)
        }
    }
    
    private func updateSubscriptionTier() {
        guard let user = firebaseAuth.user else { return }
        let db = Firestore.firestore()
        db.collection("USERS").document(user.id).updateData([
            "subscription_tier": selectedTier
        ]) { error in
            if let error = error {
                print("Error updating subscription tier: \(error)")
            } else {
                firebaseAuth.user?.subscriptionTier = selectedTier
            }
        }
    }
    
    private func benefits(for tier: String) -> String {
        switch tier {
        case "Silver":
            return "Benefits of Silver: \n- Flexible Vehicle Switching \n- Inclusive Insurance and Maintenance \n- Seamless Digital Experience \n- An economical selection of reliable and efficient vehicles, including compact cars and standard sedans"
        case "Gold":
            return "Benefits of Gold: \n- Flexible Vehicle Switching \n- Inclusive Insurance and Maintenance \n- Seamless Digital Experience \n- A range of mid-tier vehicles, including comfortable sedans, family SUVs, and versatile crossovers"
        case "Platinum":
            return "Benefits of Platinum: \n- Flexible Vehicle Switching \n- Inclusive Insurance and Maintenance \n- Seamless Digital Experience \n- Access to the most luxurious and high-end vehicles, including sports cars, premium SUVs, and executive sedans"
        default:
            return ""
        }
    }
    
    private func tierImageName(for tier: String) -> String {
        switch tier {
        case "Silver":
            return "SilverTier"
        case "Gold":
            return "GoldTier"
        case "Platinum":
            return "PlatinumTier"
        default:
            return "DefaultTier"
        }
    }
}

struct ChangeTierView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeTierView().environmentObject(FirebaseAuthHelper())
    }
}
