import SwiftUI

struct PaymentPage: View {
    let vehicle: Vehicle
    let user: User

    @State private var isEligible: Bool = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Booking Summary Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Booking ID: XYZ123") // Placeholder for booking ID
                    if let url = URL(string: vehicle.imageUrl), UIApplication.shared.canOpenURL(url) {
                        RemoteImageView(urlString: vehicle.imageUrl)
                            .frame(height: 200)
                            .cornerRadius(10)
                    } else {
                        Image(vehicle.imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                    Text("Vehicle: \(vehicle.name)")
                    Text("Car Type: \(vehicle.carType)")
                    Text("Transmission: \(vehicle.transmissionType)")
                    Text("Fuel: \(vehicle.fuel)")
                    Text("Date of Pickup: June 20, 2024") // Placeholder for date of pickup
                    Text("Pickup Location: Your location") // Placeholder for pickup location
                }
                .padding()

                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Spacer()

                // Proceed to Payment Button
                if isEligible {
                    NavigationLink(destination: ReceiptView(vehicle: vehicle)) {
                        Text("Proceed to Payment")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                            .cornerRadius(10)
                    }
                } else {
                    Text("You are not eligible to book this car with your current subscription tier.")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .navigationBarTitle("Booking Summary", displayMode: .inline)
        }
        .onAppear {
            checkEligibility()
        }
    }

    private func checkEligibility() {
        switch vehicle.subscriptionTier.lowercased() {
        case "platinum":
            isEligible = user.subscriptionTier.lowercased() == "platinum"
        case "gold":
            isEligible = user.subscriptionTier.lowercased() == "platinum" || user.subscriptionTier.lowercased() == "gold"
        case "silver":
            isEligible = true
        default:
            isEligible = false
        }

        if !isEligible {
            errorMessage = "Your subscription tier does not allow booking this vehicle."
        }
    }
}

struct PaymentPage_Previews: PreviewProvider {
    static var previews: some View {
        PaymentPage(
            vehicle: Vehicle(
                id: "1",
                name: "Tesla Model S",
                description: "A premium electric sedan",
                imageUrl: "tesla_model_s", // Update to match asset name for local testing
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
            ),
            user: User(
                id: "123",
                name: "John Doe",
                email: "johndoe@example.com",
                subscriptionTier: "Gold",
                currentVehicleId: ""
            )
        )
    }
}

