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
    var product: Product?
    var unitPrice: Decimal = 0
    var quantity: Int = 1
    
    var purchase: Purchase?
    
    init(product: Product, unitPrice: Decimal? = nil, quantity: Int, purchase: Purchase? = nil) {
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
