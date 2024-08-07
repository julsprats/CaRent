import SwiftUI
import MapKit

struct HistoryView: View {
    @State private var bookings: [Booking] = []
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if bookings.isEmpty {
                Text("No car booked")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(bookings) { booking in
                    NavigationLink(destination: BookingDetailView(
                        booking: booking,
                        bookings: $bookings,
                        location: CLLocationCoordinate2D(latitude: 43.651070, longitude: -79.347015) // Default location
                    ).environmentObject(FirebaseAuthHelper())) {
                        HStack {
                            if let url = URL(string: booking.imageUrl), UIApplication.shared.canOpenURL(url) {
                                RemoteImageView(urlString: booking.imageUrl)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                    .padding(.trailing, 10)
                            } else {
                                Image(booking.imageUrl)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                    .padding(.trailing, 10)
                            }

                            VStack(alignment: .leading) {
                                Text(booking.vehicleName)
                                    .font(.headline)
                                Text(booking.vehicleDescription)
                                    .font(.subheadline)
                                Text("Booked on: \(booking.bookingDate, formatter: DateFormatter.shortDateTime)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                if booking.status == "Cancelled" {
                                    Text("Status: Cancelled")
                                        .font(.footnote)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                Button(action: clearHistory) {
                    Text("Clear History")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
        }
        .onAppear {
            loadBookings()
        }
        .navigationBarTitle("Switch History", displayMode: .inline)
    }

    private func loadBookings() {
        if let data = UserDefaults.standard.data(forKey: "bookings") {
            let decoder = JSONDecoder()
            if let bookings = try? decoder.decode([Booking].self, from: data) {
                self.bookings = bookings
            } else {
                errorMessage = "Failed to load bookings."
            }
        } else {
            bookings = []
        }
    }
    
    private func clearHistory() {
        UserDefaults.standard.removeObject(forKey: "bookings")
        bookings.removeAll()
    }
}

extension DateFormatter {
    static let shortDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environmentObject(FirebaseAuthHelper())
    }
}

