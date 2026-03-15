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
    var phoneNumber: String = ""
    var name: String = ""
    
    var dateCreated = Date.now
    
    var purchases: [Purchase]? = []
    
    init(phoneNumber: String, name: String) {
        self.phoneNumber = phoneNumber
        self.name = name
    }
}

extension Customer {
    var totalDebt: Decimal {
        purchases?
            .filter { !$0.isPaid }
            .reduce(Decimal(0)) { $0 + $1.totalPrice }
        ?? 0
    }
}

// MARK: -
extension Customer {
    static let sampleData = [
        Customer(phoneNumber: "+5511987654321", name: "João Silva"),
        Customer(phoneNumber: "+5511987654321", name: "Maria Oliveira"),
        Customer(phoneNumber: "+5511987654321", name: "Carlos Souza"),
        Customer(phoneNumber: "+5511987654321", name: "Ana Costa"),
        Customer(phoneNumber: "+5511987654321", name: "Pedro Santos"),
        Customer(phoneNumber: "+5511987654321", name: "Luciana Lima"),
        Customer(phoneNumber: "+5511987654321", name: "Marcos Pereira"),
        Customer(phoneNumber: "+5511987654321", name: "Fernanda Rocha"),
        Customer(phoneNumber: "+5511987654321", name: "Rafael Alves"),
        Customer(phoneNumber: "+5511987654321", name: "Patrícia Mendes"),
    ]
}
