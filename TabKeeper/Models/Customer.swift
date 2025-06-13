//
//  Customer.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 13/06/25.
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
