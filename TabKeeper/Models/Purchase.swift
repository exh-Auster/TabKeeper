//
//  Purchase.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 13/06/25.
//

import Foundation
import SwiftData

@Model
class Purchase {
    var id: UUID
    var date: Date
    var customer: Customer?
    
    var comment: String = ""
    
    var items: [Item] = []
    
    var isPaid: Bool = false
    var datePaid: Date?
    
    init(
        id: UUID = UUID(),
        date: Date = Date.now,
        customer: Customer,
        items: [Item] = [],
        isPaid: Bool = false,
        datePaid: Date? = nil
    ) {
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
