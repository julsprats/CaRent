//
//  User.swift
//  CaRent
//
//  Created by Julia Prats on 2024-05-23.
//

import Foundation

struct User: Codable {
    var id: String
    var name: String
    var email: String
    var subscriptionTier: String
    var currentVehicleId: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case subscriptionTier = "subscription_tier"
        case currentVehicleId = "current_vehicle_id"
    }
}

