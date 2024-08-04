import SwiftUI
import CoreLocation

struct PaymentPage: View {
    let vehicle: Vehicle
    let user: User
    let userLocation: CLLocationCoordinate2D?

    @State private var isEligible: Bool = true
    @State private var errorMessage: String?
    @State private var locationDescription: String = "Your location"

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
                    Text("Date of Pickup: August 8, 2024")
                    Text("Pickup Location: \(locationDescription)")
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
                    NavigationLink(destination: ReceiptView(vehicle: vehicle, userLocation: locationDescription)) {
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
            if let location = userLocation {
                getAddressFromCoordinates(location: location)
            }
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

    private func getAddressFromCoordinates(location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            if let error = error {
                print("Failed to find user's location: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let country = placemark.country ?? ""
                locationDescription = "\(city), \(country)"
            }
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
            ),
            userLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Example coordinates for preview
        )
    }
}

