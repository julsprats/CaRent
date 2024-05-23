import Foundation

class JSONLoader {
    static func loadVehicles() -> [Vehicle] {
        guard let url = Bundle.main.url(forResource: "vehicles", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load JSON file.")
            return []
        }

        let decoder = JSONDecoder()
        do {
            let vehicles = try decoder.decode([Vehicle].self, from: data)
            return vehicles
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}

