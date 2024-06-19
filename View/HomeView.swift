import SwiftUI

struct HomeView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @State private var currentVehicle: Vehicle?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let user = firebaseAuth.user {
                    // Welcome message
                    Text("Welcome, \(user.name)!")
                        .font(.largeTitle)
                        .bold()

                    // Subscription tier button
                    NavigationLink(destination: ChangeTierView().environmentObject(firebaseAuth)) {
                        Text("Subscription Tier: \(user.subscriptionTier)")
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 208/255, green: 152/255, blue: 0/255), lineWidth: 2) // Gold border
                            )
                    }
                    .padding(.bottom, 10)
                                    
                    Spacer()

                    // Current vehicle information
                    VStack(alignment: .leading) {
                        if let vehicle = currentVehicle {
                            Text("Current Vehicle")
                                .font(.title)
                                .bold()
                                .padding(.horizontal)
                            
                            NavigationLink(destination: CurrentCarView(vehicle: vehicle)) {
                                VStack {
                                    HStack {
                                        Spacer() // Pushes content to the center

                                        if let url = URL(string: vehicle.imageUrl), UIApplication.shared.canOpenURL(url) {
                                            RemoteImageView(urlString: vehicle.imageUrl)
                                                .frame(width: 150, height: 100)
                                                .cornerRadius(10)
                                        } else {
                                            Image(vehicle.imageUrl)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 150, height: 100)
                                                .cornerRadius(10)
                                        }

                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(vehicle.name)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text(vehicle.description)
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            Text("Seats: \(vehicle.seats), Doors: \(vehicle.doors)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }

                                        Spacer() // Pushes content to the center
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                }
                            }
                        } else {
                            Text("No current bookings")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }

                        // Switch vehicle button
                        NavigationLink(destination: SearchView(user: user).environmentObject(firebaseAuth)) {
                            Text("Switch Vehicle")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 208/255, green: 152/255, blue: 0/255)) // Gold
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                } else {
                    Text("Loading user data...")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                }
            }
            .padding()
            .onAppear {
                loadCurrentVehicle()
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }

    private func loadCurrentVehicle() {
        if let data = UserDefaults.standard.data(forKey: "currentVehicle"),
           let vehicle = try? JSONDecoder().decode(Vehicle.self, from: data) {
            self.currentVehicle = vehicle
        }
    }

    private func clearCurrentVehicle() {
        UserDefaults.standard.removeObject(forKey: "currentVehicle")
        self.currentVehicle = nil
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(FirebaseAuthHelper())
    }
}
