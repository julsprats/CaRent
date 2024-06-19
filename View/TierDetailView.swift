//
//  TierDetailView.swift
//  CaRent
//
//  Created by Julia Prats on 2024-06-09.
//

import SwiftUI
import FirebaseFirestore

struct TierDetailView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    let tier: String

    var body: some View {
        VStack(spacing: 20) {
            Text(tier)
                .font(.title)
                .bold()
            
            Image(tierImageName(for: tier))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            Text(benefits(for: tier))
                .padding()
            
            Button(action: {
                updateSubscriptionTier(to: tier)
            }) {
                Text("Change to \(tier) Tier")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func updateSubscriptionTier(to tier: String) {
        guard let user = firebaseAuth.user else { return }
        let db = Firestore.firestore()
        db.collection("USERS").document(user.id).updateData([
            "subscription_tier": tier
        ]) { error in
            if let error = error {
                print("Error updating subscription tier: \(error)")
            } else {
                firebaseAuth.user?.subscriptionTier = tier
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

struct TierDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TierDetailView(tier: "Gold").environmentObject(FirebaseAuthHelper())
    }
}
