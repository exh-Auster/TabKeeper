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

// MARK: -
extension Purchase {
    static let sampleData = [
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-100 * 86400)),
            customer: Customer.sampleData[1],
            items: [
                Item(product: Product.sampleData[0], quantity: 10),
                Item(product: Product.sampleData[7], quantity: 3)
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-95 * 86400)),
            customer: Customer.sampleData[1],
            items: [
                Item(product: Product.sampleData[4], quantity: 5),
                Item(product: Product.sampleData[11], quantity: 1)
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-2 * 86400)),
            customer: Customer.sampleData[2],
            items: [
                Item(product: Product.sampleData[7], quantity: 5),
                Item(product: Product.sampleData[11], quantity: 3)
            ],
            isPaid: false
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-30 * 86400)),
            customer: Customer.sampleData[3],
            items: [
                Item(product: Product.sampleData[7], quantity: 5),
                Item(product: Product.sampleData[11], quantity: 3)
            ],
            isPaid: false
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-25 * 86400)),
            customer: Customer.sampleData[3],
            items: [
                Item(product: Product.sampleData[6], quantity: 5),
                Item(product: Product.sampleData[11], quantity: 1)
            ],
            isPaid: false
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-20 * 86400)),
            customer: Customer.sampleData[3],
            items: [
                Item(product: Product.sampleData[3], quantity: 5),
                Item(product: Product.sampleData[9], quantity: 3)
            ],
            isPaid: false
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-2 * 86400)),
            customer: Customer.sampleData[4],
            items: [
                Item(product: Product.sampleData[1], quantity: 5),
                Item(product: Product.sampleData[3], quantity: 3)
            ],
            isPaid: false
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-2 * 86400)),
            customer: Customer.sampleData[5],
            items: [
                Item(product: Product.sampleData[0], quantity: 1),
                Item(product: Product.sampleData[1], quantity: 2),
                Item(product: Product.sampleData[2], quantity: 3),
                Item(product: Product.sampleData[3], quantity: 4),
                Item(product: Product.sampleData[4], quantity: 5),
                Item(product: Product.sampleData[5], quantity: 6),
                Item(product: Product.sampleData[6], quantity: 7),
                Item(product: Product.sampleData[7], quantity: 8),
                Item(product: Product.sampleData[8], quantity: 9),
                Item(product: Product.sampleData[9], quantity: 10),
                Item(product: Product.sampleData[10], quantity: 11),
                Item(product: Product.sampleData[11], quantity: 12),
            ],
            isPaid: false
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-2 * 86400)),
            customer: Customer.sampleData[6],
            items: [
                Item(product: Product.sampleData[0], quantity: 1),
                Item(product: Product.sampleData[1], quantity: 2),
                Item(product: Product.sampleData[2], quantity: 3),
                Item(product: Product.sampleData[3], quantity: 4),
                Item(product: Product.sampleData[4], quantity: 5),
                Item(product: Product.sampleData[5], quantity: 6),
                Item(product: Product.sampleData[6], quantity: 7),
                Item(product: Product.sampleData[7], quantity: 8),
                Item(product: Product.sampleData[8], quantity: 9),
                Item(product: Product.sampleData[9], quantity: 10),
                Item(product: Product.sampleData[10], quantity: 11),
                Item(product: Product.sampleData[11], quantity: 12),
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-2 * 86400)),
            customer: Customer.sampleData[7],
            items: [
                Item(product: Product.sampleData[0], quantity: 1),
                Item(product: Product.sampleData[1], quantity: 2),
                Item(product: Product.sampleData[2], quantity: 3),
                Item(product: Product.sampleData[3], quantity: 4),
                Item(product: Product.sampleData[4], quantity: 5),
                Item(product: Product.sampleData[5], quantity: 6),
                Item(product: Product.sampleData[6], quantity: 7),
                Item(product: Product.sampleData[7], quantity: 8),
                Item(product: Product.sampleData[8], quantity: 9),
                Item(product: Product.sampleData[9], quantity: 10),
                Item(product: Product.sampleData[10], quantity: 11),
            ],
            isPaid: false
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-2 * 86400)),
            customer: Customer.sampleData[7],
            items: [
                Item(product: Product.sampleData[0], quantity: 1),
                Item(product: Product.sampleData[1], quantity: 2),
                Item(product: Product.sampleData[2], quantity: 3),
                Item(product: Product.sampleData[3], quantity: 4),
                Item(product: Product.sampleData[4], quantity: 5),
                Item(product: Product.sampleData[5], quantity: 6),
                Item(product: Product.sampleData[6], quantity: 7),
                Item(product: Product.sampleData[7], quantity: 8),
                Item(product: Product.sampleData[8], quantity: 9),
                Item(product: Product.sampleData[9], quantity: 10),
                Item(product: Product.sampleData[10], quantity: 11),
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-100 * 86400)),
            customer: Customer.sampleData[8],
            items: [
                Item(product: Product.sampleData[0], quantity: 10),
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-95 * 86400)),
            customer: Customer.sampleData[8],
            items: [
                Item(product: Product.sampleData[4], quantity: 5),
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-100 * 86400)),
            customer: Customer.sampleData[8],
            items: [
                Item(product: Product.sampleData[0], quantity: 10),
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-95 * 86400)),
            customer: Customer.sampleData[8],
            items: [
                Item(product: Product.sampleData[4], quantity: 5),
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-100 * 86400)),
            customer: Customer.sampleData[8],
            items: [
                Item(product: Product.sampleData[0], quantity: 10),
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-95 * 86400)),
            customer: Customer.sampleData[8],
            items: [
                Item(product: Product.sampleData[4], quantity: 5),
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-100 * 86400)),
            customer: Customer.sampleData[8],
            items: [
                Item(product: Product.sampleData[0], quantity: 10),
            ],
            isPaid: true
        ),
        Purchase(
            date: Date().addingTimeInterval(TimeInterval(-95 * 86400)),
            customer: Customer.sampleData[8],
            items: [
                Item(product: Product.sampleData[4], quantity: 5),
            ],
            isPaid: true
        ),
    ]
}
