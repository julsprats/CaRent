import SwiftUI

struct ReceiptView: View {
    let vehicle: Vehicle
    @State private var selectedOption: PricingOption?
    @State private var showConfirmation: Bool = false
    @State private var showBill: Bool = false

    enum PricingOption: String {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }

    private var pricing: [PricingOption: Double] {
        switch vehicle.subscriptionTier.lowercased() {
        case "platinum":
            return [.daily: 100.0, .weekly: 600.0, .monthly: 2000.0]
        case "gold":
            return [.daily: 75.0, .weekly: 450.0, .monthly: 1500.0]
        case "silver":
            return [.daily: 50.0, .weekly: 300.0, .monthly: 1000.0]
        default:
            return [.daily: 0.0, .weekly: 0.0, .monthly: 0.0]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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

            Text("Select a pricing option:")
                .font(.headline)

            HStack {
                PricingOptionButton(option: .daily, selectedOption: $selectedOption, pricing: pricing)
                PricingOptionButton(option: .weekly, selectedOption: $selectedOption, pricing: pricing)
                PricingOptionButton(option: .monthly, selectedOption: $selectedOption, pricing: pricing)
            }

            Spacer()

            if let selectedOption = selectedOption {
                Button(action: {
                    showBill = true
                }) {
                    Text("Proceed to Payment")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showBill) {
                    BillView(vehicle: vehicle, selectedOption: selectedOption, price: pricing[selectedOption]!)
                }
            }
        }
        .padding()
        .navigationBarTitle("Receipt", displayMode: .inline)
    }
}

struct PricingOptionButton: View {
    let option: ReceiptView.PricingOption
    @Binding var selectedOption: ReceiptView.PricingOption?
    let pricing: [ReceiptView.PricingOption: Double]

    var body: some View {
        Button(action: {
            selectedOption = option
        }) {
            VStack {
                Text(option.rawValue)
                    .font(.headline)
                Text(String(format: "$%.2f", pricing[option]!))
                    .font(.subheadline)
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(selectedOption == option ? Color(red: 208/255, green: 152/255, blue: 0/255) : Color.gray)
            .cornerRadius(10)
        }
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptView(vehicle: Vehicle(
            id: "1",
            name: "Tesla Model S",
            description: "A premium electric sedan",
            imageUrl: "tesla_model_S", // Update to match asset name for local testing
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
        ))
    }
}

