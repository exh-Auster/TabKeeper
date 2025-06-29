//
//  Product.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 13/06/25.
//

import Foundation
import SwiftData

@Model
class Product: Identifiable, Hashable {
    var id: UUID
    var name: String
    var details: String
    var price: Decimal
    
    init(id: UUID = UUID(), name: String, details: String = "", price: Decimal) {
        self.id = id
        self.name = name
        self.details = details
        self.price = price
    }
}

// MARK: -
extension Product {
    static let sampleData = [
        Product(name: "Item 1", details: "300g", price: 1),
        Product(name: "Item 2", price: 2),
        Product(name: "Item 3", details: "Retornável", price: 3),
        Product(name: "Item 4", price: 4),
        Product(name: "Item 5", price: 0.50),
        Product(name: "Item 6", price: 6),
        Product(name: "Item 7", details: "300ml", price: 7),
        Product(name: "Item 8", price: 8),
        Product(name: "Item 9", details: "Limão", price: 9),
        Product(name: "Item 10", price: 10.10),
        Product(name: "Item 11", price: 11),
        Product(name: "Item 12", price: 12),
    ]
}
