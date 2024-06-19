import Foundation

class JSONLoader {
    static func loadVehicles() -> [Vehicle] {
        guard let url = Bundle.main.url(forResource: "vehicles", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to locate or load JSON file.")
            return []
        }

        // Print the JSON data for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON Data: \(jsonString)")
        } else {
            print("Failed to convert data to JSON string.")
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode([Vehicle].self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}

