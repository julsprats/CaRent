//
//  Vehicle.swift
//  CaRent
//
//  Created by Jasdeep Singh on 2024-06-03.
//

import Foundation


struct Vehicle: Identifiable, Decodable, Encodable {
    let id: String
    let name: String
    let description: String
    let imageUrl: String
    let subscriptionTier: String
    let carType: String
    let transmissionType: String
    let fuel: String
    let coolSeat: Bool
    let acceleration: String
    let seats: Int
    let doors: Int
    let brand: String
    let price: Double
  
}
