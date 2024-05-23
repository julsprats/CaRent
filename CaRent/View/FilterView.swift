import SwiftUI

struct FilterView: View {
    @Binding var selectedSubscriptionTier: String
    @Binding var selectedCarType: String
    @Binding var selectedTransmissionType: String
    @Binding var selectedFuelType: String
    @Binding var selectedPriceRange: ClosedRange<Double>
    @Binding var selectedDoors: Int
    @Binding var selectedBrand: String

    let subscriptionTiers = ["All", "Silver", "Gold", "Platinum"]
    let carTypes = ["All", "SUV", "Sedan", "Coupe"]
    let transmissionTypes = ["All", "Automatic", "Manual"]
    let fuelTypes = ["All", "Petrol", "Diesel", "Electric", "Hybrid"]
    let brands = ["All", "Mercedes", "BMW", "Porsche", "Maserati", "Renault"]
    let doors = [0, 2, 4, 5]
    let priceRange: ClosedRange<Double> = 0...100000

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Subscription Tier")) {
                    Picker("Subscription Tier", selection: $selectedSubscriptionTier) {
                        ForEach(subscriptionTiers, id: \.self) { tier in
                            Text(tier).tag(tier)
                        }
                    }
                }
                
                Section(header: Text("Car Type")) {
                    Picker("Car Type", selection: $selectedCarType) {
                        ForEach(carTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }
                
                Section(header: Text("Transmission Type")) {
                    Picker("Transmission Type", selection: $selectedTransmissionType) {
                        ForEach(transmissionTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }
                
                Section(header: Text("Fuel Type")) {
                    Picker("Fuel Type", selection: $selectedFuelType) {
                        ForEach(fuelTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }

                Section(header: Text("Price Range")) {
                    Slider(value: Binding(get: {
                        selectedPriceRange.lowerBound
                    }, set: { newValue in
                        selectedPriceRange = newValue...selectedPriceRange.upperBound
                    }), in: priceRange, step: 1000)
                    Slider(value: Binding(get: {
                        selectedPriceRange.upperBound
                    }, set: { newValue in
                        selectedPriceRange = selectedPriceRange.lowerBound...newValue
                    }), in: priceRange, step: 1000)
                    Text("Price: \(Int(selectedPriceRange.lowerBound)) - \(Int(selectedPriceRange.upperBound))")
                }
                
                Section(header: Text("Number of Doors")) {
                    Picker("Number of Doors", selection: $selectedDoors) {
                        ForEach(doors, id: \.self) { door in
                            Text("\(door)").tag(door)
                        }
                    }
                }
                
                Section(header: Text("Car Brand")) {
                    Picker("Car Brand", selection: $selectedBrand) {
                        ForEach(brands, id: \.self) { brand in
                            Text(brand).tag(brand)
                        }
                    }
                }
            }
            .navigationBarTitle("Filter Options", displayMode: .inline)
            .navigationBarItems(trailing: Button("Apply") {
                // Handle apply action
            })
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(
            selectedSubscriptionTier: .constant("All"),
            selectedCarType: .constant("All"),
            selectedTransmissionType: .constant("All"),
            selectedFuelType: .constant("All"),
            selectedPriceRange: .constant(0...100000),
            selectedDoors: .constant(0),
            selectedBrand: .constant("All")
        )
    }
}

