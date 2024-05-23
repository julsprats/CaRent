//
//  Booking.swift
//  CaRent
//
//  Created by Jasdeep Singh on 2024-06-04.
//

import Foundation

struct Booking: Identifiable, Codable {
    var id: String
    var vehicleName: String
    var vehicleDescription: String
    var bookingDate: Date
    var imageUrl: String
    var status: String

    enum CodingKeys: String, CodingKey {
        case id
        case vehicleName = "vehicle_name"
        case vehicleDescription = "vehicle_description"
        case bookingDate = "booking_date"
        case imageUrl = "image_url"
        case status
    }
}

