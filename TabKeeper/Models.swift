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
    
    init(id: UUID, phoneNumber: String, name: String, purchases: [Purchase]) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.name = name
        self.purchases = purchases
    }
}

@Model
class Purchase {
    var id: UUID
    var date: Date
    var customer: Customer
    
    var items: [Item] = []
    
    init(id: UUID, customer: Customer, date: Date, items: [Item]) {
        self.id = id
        self.customer = customer
        self.date = date
        self.items = items
    }
}

@Model
class Item {
    var id: UUID
    var name: String
    var price: Decimal
    var quantity: Int
    
    var purchase: Purchase
    
    init(id: UUID, name: String, price: Decimal, quantity: Int, purchase: Purchase) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.purchase = purchase
    }
}
