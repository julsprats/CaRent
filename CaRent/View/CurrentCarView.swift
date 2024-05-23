import Foundation
import SwiftUI

struct CurrentCarView: View {
    let vehicle: Vehicle

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let url = URL(string: vehicle.imageUrl), UIApplication.shared.canOpenURL(url) {
                RemoteImageView(urlString: vehicle.imageUrl)
                    .frame(width: 300, height: 200)
                    .cornerRadius(10)
            } else {
                Image(vehicle.imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 200)
                    .cornerRadius(10)
            }

            // Specifications section
            VStack(alignment: .leading, spacing: 10) {
                Text("Specifications")
                    .font(.title)
                    .padding(.bottom, 5)
                
                HStack {
                    SpecsView(title: "Fuel", value: vehicle.fuel)
                    SpecsView(title: "Cool Seat", value: vehicle.coolSeat ? "Yes" : "No")
                    SpecsView(title: "Acceleration", value: vehicle.acceleration)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // Car details section
            VStack(alignment: .leading, spacing: 10) {
                Text("Car Details")
                    .font(.title)
                    .padding(.bottom, 5)
                
                CarRowView(title: "Number of Seats", value: "\(vehicle.seats)")
                CarRowView(title: "Doors", value: "\(vehicle.doors)")
                CarRowView(title: "Transmission", value: vehicle.transmissionType)
                CarRowView(title: "Car Type", value: vehicle.carType)
                CarRowView(title: "Air Conditioning", value: "Yes")
                CarRowView(title: "Price", value: String(format: "$%.2f", vehicle.price))
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle(Text(vehicle.name), displayMode: .inline)
    }
}

struct CarRowView: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
        }
    }
}

struct SpecsView: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.subheadline)
        }
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct CurrentCarView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentCarView(
            vehicle: Vehicle(
                id: "1",
                name: "Tesla Model S",
                description: "A premium electric sedan",
                imageUrl: "tesla_model_S", // This should match an asset name for local testing
                subscriptionTier: "Platinum",
                carType: "Sedan",
                transmissionType: "Automatic",
                fuel: "Electric",
                coolSeat: true,
                acceleration: "3.1s",
                seats: 5,
                doors: 5,
                brand: "Tesla",
                price: 79999.99
            )
        )
    }
}

