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
    var id: UUID = UUID()
    var phoneNumber: String
    var name: String
    
    var dateCreated = Date.now
    
    var purchases: [Purchase] = []
    
    init(phoneNumber: String, name: String) {
        self.phoneNumber = phoneNumber
        self.name = name
    }
}

@Model
class Purchase {
    var id: UUID = UUID()
    var date: Date
    var customer: Customer?
    
    var items: [Item] = []
    var isPaid: Bool = false
    
    init(date: Date = Date.now, customer: Customer, items: [Item] = [], isPaid: Bool = false) {
        self.date = date
        self.customer = customer
        self.items = items
        self.isPaid = isPaid
    }
}

@Model
class Item {
    var id: UUID = UUID()
    var name: String
    var price: Decimal
    var quantity: Int
    
    var purchase: Purchase?
    
    init(name: String, price: Decimal, quantity: Int, purchase: Purchase) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.purchase = purchase
    }
}
