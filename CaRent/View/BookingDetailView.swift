import SwiftUI

struct BookingDetailView: View {
    var booking: Booking
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @Binding var bookings: [Booking]
    @State private var showConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("Vehicle: \(booking.vehicleName)")
            Text("Description: \(booking.vehicleDescription)")
            Text("Booking Date: \(booking.bookingDate, formatter: DateFormatter.shortDateTime)")

            if let url = URL(string: booking.imageUrl), UIApplication.shared.canOpenURL(url) {
                RemoteImageView(urlString: booking.imageUrl)
                    .frame(height: 200)
                    .cornerRadius(10)
            } else {
                Image(booking.imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(10)
            }

            Spacer()

            Button(action: {
                showConfirmation = true
            }) {
                Text("Cancel Booking")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                    .cornerRadius(10)
            }
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("Cancel Booking"),
                    message: Text("Are you sure you want to cancel this booking?"),
                    primaryButton: .destructive(Text("Cancel")) {
                        cancelBooking()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding()
        .navigationBarTitle("Booking Details", displayMode: .inline)
    }

    private func cancelBooking() {
        if let index = bookings.firstIndex(where: { $0.id == booking.id }) {
            bookings[index].status = "Cancelled"
            saveBookings(bookings: bookings)
            markVehicleAsAvailable(booking.vehicleName)
            clearCurrentVehicle()
        }
    }

    private func saveBookings(bookings: [Booking]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(bookings) {
            UserDefaults.standard.set(data, forKey: "bookings")
        }
    }

    private func markVehicleAsAvailable(_ vehicleName: String) {
        var unavailableVehicles = loadUnavailableVehicles()
        if let index = unavailableVehicles.firstIndex(of: vehicleName) {
            unavailableVehicles.remove(at: index)
            saveUnavailableVehicles(unavailableVehicles)
        }
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

    private func clearCurrentVehicle() {
        UserDefaults.standard.removeObject(forKey: "currentVehicle")
    }
}

struct BookingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookingDetailView(
            booking: Booking(
                id: "1",
                vehicleName: "Tesla Model S",
                vehicleDescription: "A premium electric sedan",
                bookingDate: Date(),
                imageUrl: "tesla_model_S", // Update to match asset name for local testing
                status: "Active"
            ),
            bookings: .constant(LocalData.bookings)
        ).environmentObject(FirebaseAuthHelper())
    }
}

