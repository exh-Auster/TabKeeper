//
//  Models.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import Foundation
import SwiftData

@Model
class Customer {
    var id: UUID
    var phoneNumber: String
    var name: String
    
    var dateCreated = Date.now
    
    var purchases: [Purchase] = []
    
    init(id: UUID = UUID(), phoneNumber: String, name: String) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.name = name
    }
}

extension Customer {
    var totalDebt: Decimal {
        purchases
            .filter { !$0.isPaid }
            .reduce(Decimal(0)) { $0 + $1.totalPrice }
    }
}

@Model
class Purchase {
    var id: UUID
    var date: Date
    var customer: Customer?
    
    var comment: String = ""
    
    var items: [Item] = []
    var isPaid: Bool = false
    
    init(id: UUID = UUID(), date: Date = Date.now, customer: Customer, items: [Item] = [], isPaid: Bool = false) {
        self.id = id
        self.date = date
        self.customer = customer
        self.items = items
        self.isPaid = isPaid
    }
}

extension Purchase {
    var totalQuantity: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Decimal {
        items.reduce(Decimal(0)) { $0 + $1.totalPrice }
    }
}

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
