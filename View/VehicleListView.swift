// VehicleListView.swift
// CaRent
//
// Created by Jasdeep Singh on 2024-06-03.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct VehicleListView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @State private var vehicles: [Vehicle] = []
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let subscriptionTier = firebaseAuth.user?.subscriptionTier {
                Text("Available Vehicles for \(subscriptionTier) Tier")
                    .font(.headline)
                    .padding()

                List(vehicles) { vehicle in
                    HStack {
                        if let image = UIImage(named: vehicle.imageUrl) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        VStack(alignment: .leading) {
                            Text(vehicle.name)
                                .font(.headline)
                            Text(vehicle.description)
                                .font(.subheadline)
                        }
                    }
                    .onTapGesture {
                        Task {
                            await switchVehicle(to: vehicle)
                        }
                    }
                }
                .onAppear {
                    Task {
                        await fetchVehicles()
                    }
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            } else {
                Text("No subscription tier available")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    private func fetchVehicles() async {
        guard let user = firebaseAuth.user else { return }

        do {
            let snapshot = try await Firestore.firestore().collection("VEHICLES")
                .whereField("subscriptionType", isEqualTo: user.subscriptionTier)
                .getDocuments()

            vehicles = snapshot.documents.compactMap { document in
                try? document.data(as: Vehicle.self)
            }
        } catch {
            errorMessage = "Failed to fetch vehicles: \(error.localizedDescription)"
        }
    }

    private func switchVehicle(to vehicle: Vehicle) async {
        guard let user = firebaseAuth.user else { return }

        do {
            let userDocRef = Firestore.firestore().collection("USERS").document(user.id)
            try await userDocRef.updateData(["current_vehicle_id": vehicle.id ?? ""])
            firebaseAuth.user?.currentVehicleId = vehicle.id
        } catch {
            errorMessage = "Failed to switch vehicle: \(error.localizedDescription)"
        }
    }
}

#Preview {
    VehicleListView()
        .environmentObject(FirebaseAuthHelper())
}

