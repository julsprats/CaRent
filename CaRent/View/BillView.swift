import SwiftUI

struct BillView: View {
    let vehicle: Vehicle
    let selectedOption: ReceiptView.PricingOption
    let price: Double

    @State private var showAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Bill")
                .font(.title)
                .bold()
            
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
            Text("Date of Pickup: June 20, 2024") // Placeholder for date of pickup
            Text("Pickup Location: Your location") // Placeholder for pickup location
            Text("Pricing Option: \(selectedOption.rawValue)")
            Text("Price: $\(String(format: "%.2f", price))")

            Spacer()
            
            Button(action: {
                confirmBooking()
            }) {
                Text("Confirm Payment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationBarTitle("Bill", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Booking Confirmed"), message: Text("Your booking has been confirmed and the vehicle is now unavailable."), dismissButton: .default(Text("OK")))
        }
    }

    private func confirmBooking() {
        let newBooking = Booking(
            id: UUID().uuidString,
            vehicleName: vehicle.name,
            vehicleDescription: vehicle.description,
            bookingDate: Date(), // Current date
            imageUrl: vehicle.imageUrl,
            status: "Confirmed"
        )
        
        var currentBookings = loadBookings()
        currentBookings.append(newBooking)
        saveBookings(bookings: currentBookings)
        
        markVehicleAsUnavailable(vehicle.id)
        saveCurrentVehicle(vehicle)
        
        showAlert = true
    }

    private func loadBookings() -> [Booking] {
        if let data = UserDefaults.standard.data(forKey: "bookings") {
            let decoder = JSONDecoder()
            if let bookings = try? decoder.decode([Booking].self, from: data) {
                return bookings
            }
        }
        return []
    }

    private func saveBookings(bookings: [Booking]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(bookings) {
            UserDefaults.standard.set(data, forKey: "bookings")
        }
    }
    
    private func markVehicleAsUnavailable(_ vehicleId: String) {
        var unavailableVehicles = loadUnavailableVehicles()
        unavailableVehicles.append(vehicleId)
        saveUnavailableVehicles(unavailableVehicles)
    }

    private func loadUnavailableVehicles() -> [String] {
        if let data = UserDefaults.standard.data(forKey: "unavailableVehicles") {
            let decoder = JSONDecoder()
            if let vehicles = try? decoder.decode([String].self, from: data) {
                return vehicles
            }
        }
        return []
    }

    private func saveUnavailableVehicles(_ vehicles: [String]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(vehicles) {
            UserDefaults.standard.set(data, forKey: "unavailableVehicles")
        }
    }
    
    private func saveCurrentVehicle(_ vehicle: Vehicle) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(vehicle) {
            UserDefaults.standard.set(data, forKey: "currentVehicle")
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView(
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
                doors: 4,
                brand: "Tesla",
                price: 79999.99
            ),
            selectedOption: .monthly,
            price: 2000.0
        )
    }
}

