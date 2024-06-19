import SwiftUI

struct SearchView: View {
    @State private var vehicles: [Vehicle] = []
    @State private var searchText: String = ""
    @State private var selectedSubscriptionTier: String = "All"
    @State private var selectedCarType: String = "All"
    @State private var selectedTransmissionType: String = "All"
    @State private var selectedBrands: Set<String> = []
    @State private var errorMessage: String?
    @State private var unavailableVehicles: [String] = []
    let user: User
    
    let trendingBrands = ["Mercedes", "BMW", "Porsche", "Maserati", "Ferrari"]
    let subscriptionTiers = ["All", "Silver", "Gold", "Platinum"]
    let carTypes = ["All", "SUV", "Sedan", "Coupe"]
    let transmissionTypes = ["All", "Automatic", "Manual"]
    
    var filteredVehicles: [Vehicle] {
        return vehicles.filter { vehicle in
            (searchText.isEmpty || vehicle.name.localizedCaseInsensitiveContains(searchText)) &&
            (selectedSubscriptionTier == "All" || vehicle.subscriptionTier == selectedSubscriptionTier) &&
            (selectedCarType == "All" || vehicle.carType == selectedCarType) &&
            (selectedTransmissionType == "All" || vehicle.transmissionType == selectedTransmissionType) &&
            (selectedBrands.isEmpty || selectedBrands.contains(vehicle.brand))
        }
    }

    var body: some View {
        ZStack {

            VStack(alignment: .leading) {
                // Search bar
                TextField("Search a vehicle", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                // Filter by subscription tier
                Picker("Subscription Tier", selection: $selectedSubscriptionTier) {
                    ForEach(subscriptionTiers, id: \.self) { tier in
                        Text(tier).tag(tier)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Filter by car type
                Picker("Car Type", selection: $selectedCarType) {
                    ForEach(carTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Filter by transmission type
                Picker("Transmission Type", selection: $selectedTransmissionType) {
                    ForEach(transmissionTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Trending brands section
                Text("Trending Brands")
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(trendingBrands, id: \.self) { brand in
                            BrandFilterView(brand: brand, isSelected: selectedBrands.contains(brand)) {
                                if selectedBrands.contains(brand) {
                                    selectedBrands.remove(brand)
                                } else {
                                    selectedBrands.insert(brand)
                                }
                            }
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
                                                    .foregroundColor(.black)
                                                Text(vehicle.description)
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)
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

struct BrandFilterView: View {
    let brand: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Image(brand)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .background(isSelected ? Color(red: 208/255, green: 152/255, blue: 0/255).opacity(0.5) : Color.gray.opacity(0.2))
                .clipShape(Circle())
                .onTapGesture {
                    action()
                }
            
            Text(brand)
                .font(.headline)
                .padding(.top, 5)
        }
        .padding()
        .background(isSelected ? Color(red: 208/255, green: 152/255, blue: 0/255).opacity(0.5) : Color.gray.opacity(0.2))
        .cornerRadius(10)
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

