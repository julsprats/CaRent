import SwiftUI

struct CarDetailView: View {
    let vehicle: Vehicle
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
            
            // Specifications section
            VStack(alignment: .leading, spacing: 10) {
                Text("Specifications")
                    .font(.title)
                    .padding(.bottom, 5)
                
                HStack {
                    SpecificationView(title: "Fuel", value: vehicle.fuel)
                    SpecificationView(title: "Cool Seat", value: vehicle.coolSeat ? "Yes" : "No")
                    SpecificationView(title: "Acceleration", value: vehicle.acceleration)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            // Car details section
            VStack(alignment: .leading, spacing: 10) {
                Text("Car Details")
                    .font(.title)
                    .padding(.bottom, 5)
                
                CarDetailRowView(title: "Number of Seats", value: "\(vehicle.seats)")
                CarDetailRowView(title: "Doors", value: "\(vehicle.doors)")
                CarDetailRowView(title: "Transmission", value: vehicle.transmissionType)
                CarDetailRowView(title: "Car Type", value: vehicle.carType)
                CarDetailRowView(title: "Air Conditioning", value: "Yes")
                CarDetailRowView(title: "Price", value: String(format: "$%.2f", vehicle.price))
            }
            
            Spacer()
            
            NavigationLink(destination: PaymentPage(vehicle: vehicle, user: user)) {
                Text("Book Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationBarTitle(Text(vehicle.name), displayMode: .inline)
    }
}

struct CarDetailRowView: View {
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

struct SpecificationView: View {
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

struct CarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailView(
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
            ),
            user: User(
                id: "123",
                name: "John Doe",
                email: "",
                subscriptionTier: "Gold",
                currentVehicleId: ""
            )
        )
    }
}
