//
//  Product.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 13/06/25.
//

import Foundation
import SwiftData

@Model class Product: Identifiable, Hashable {
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
