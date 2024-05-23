import SwiftUI

struct SearchView: View {
    @State private var vehicles: [Vehicle] = []
    @State private var searchText: String = ""
    @State private var selectedSubscriptionTier: String = "All"
    @State private var selectedCarType: String = "All"
    @State private var selectedTransmissionType: String = "All"
    @State private var selectedFuelType: String = "All"
    @State private var selectedPriceRange: ClosedRange<Double> = 0...100000
    @State private var selectedDoors: Int = 0
    @State private var selectedBrand: String = "All"
    @State private var errorMessage: String?
    @State private var unavailableVehicles: [String] = []
    @State private var showFilterView: Bool = false
    let user: User
    
    let trendingBrands = ["Mercedes", "BMW", "Porsche", "Maserati", "Renault"]
    let subscriptionTiers = ["All", "Silver", "Gold", "Platinum"]
    let carTypes = ["All", "SUV", "Sedan", "Coupe"]
    let transmissionTypes = ["All", "Automatic", "Manual"]
    let fuelTypes = ["All", "Petrol", "Diesel", "Electric", "Hybrid"]
    let brands = ["All", "Mercedes", "BMW", "Porsche", "Maserati", "Renault"]
    let doors = [0, 2, 4, 5]
    
    var filteredVehicles: [Vehicle] {
        return vehicles.filter { vehicle in
            (searchText.isEmpty || vehicle.name.localizedCaseInsensitiveContains(searchText)) &&
            (selectedSubscriptionTier == "All" || vehicle.subscriptionTier == selectedSubscriptionTier) &&
            (selectedCarType == "All" || vehicle.carType == selectedCarType) &&
            (selectedTransmissionType == "All" || vehicle.transmissionType == selectedTransmissionType) &&
            (selectedFuelType == "All" || vehicle.fuel == selectedFuelType) &&
            (selectedDoors == 0 || vehicle.doors == selectedDoors) &&
            (selectedBrand == "All" || vehicle.brand == selectedBrand) &&
            (Int(selectedPriceRange.lowerBound)...Int(selectedPriceRange.upperBound)).contains(Int(vehicle.price)) &&
            !unavailableVehicles.contains(vehicle.id)
        }
    }

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // White background for the whole screen

            VStack(alignment: .leading) {
                // Search bar
                TextField("Search a vehicle", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                // Filter button
                Button(action: {
                    showFilterView.toggle()
                }) {
                    Text("Filter Options")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // Trending brands section
                Text("Trending Brands")
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(trendingBrands, id: \.self) { brand in
                            VStack {
                                Image(brand) // Assumes images are named "Mercedes.png", "BMW.png", etc.
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                
                                Text(brand)
                                    .font(.headline)
                                    .padding(.top, 5)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Popular cars section
                Text("Popular Cars")
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(filteredVehicles) { vehicle in
                            VStack(alignment: .leading) {
                                NavigationLink(destination: CarDetailView(vehicle: vehicle, user: user)) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            if let url = URL(string: vehicle.imageUrl), UIApplication.shared.canOpenURL(url) {
                                                RemoteImageView(urlString: vehicle.imageUrl)
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(10)
                                            } else {
                                                Image(vehicle.imageUrl)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(10)
                                            }
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text(vehicle.name)
                                                    .font(.headline)
                                                Text(vehicle.description)
                                                    .font(.subheadline)
                                            }
                                            Spacer()
                                            Text(unavailableVehicles.contains(vehicle.id) ? "Unavailable" : "Available")
                                                .foregroundColor(unavailableVehicles.contains(vehicle.id) ? .red : .green)
                                                .padding(.top, 5)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
            .onAppear {
                loadVehicles()
                loadUnavailableVehicles()
            }
        }
        .navigationBarTitle("Search Vehicles", displayMode: .inline)
        .sheet(isPresented: $showFilterView) {
            FilterView(
                selectedSubscriptionTier: $selectedSubscriptionTier,
                selectedCarType: $selectedCarType,
                selectedTransmissionType: $selectedTransmissionType,
                selectedFuelType: $selectedFuelType,
                selectedPriceRange: $selectedPriceRange,
                selectedDoors: $selectedDoors,
                selectedBrand: $selectedBrand
            )
        }
    }

    private func loadVehicles() {
        self.vehicles = JSONLoader.loadVehicles()
        if vehicles.isEmpty {
            self.errorMessage = "Failed to load vehicles."
        } else {
            print("Loaded Vehicles: \(vehicles)")
        }
    }

    private func loadUnavailableVehicles() {
        if let data = UserDefaults.standard.data(forKey: "unavailableVehicles") {
            let decoder = JSONDecoder()
            if let vehicles = try? decoder.decode([String].self, from: data) {
                self.unavailableVehicles = vehicles
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
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

