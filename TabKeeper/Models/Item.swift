//
//  Item.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 13/06/25.
//

import Foundation
import SwiftData

@Model
class Item {
    var id: UUID
    var product: Product
    var unitPrice: Decimal
    var quantity: Int
    
    var purchase: Purchase?
    
    init(id: UUID = UUID(), product: Product, unitPrice: Decimal? = nil, quantity: Int, purchase: Purchase? = nil) {
        self.id = id
        self.product = product
        self.unitPrice = unitPrice ?? product.price
        self.quantity = quantity
        self.purchase = purchase
    }
}

extension Item {
    var totalPrice: Decimal {
        Decimal(quantity) * unitPrice
    }
}
