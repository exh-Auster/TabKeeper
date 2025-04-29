//
//  PreviewSampleData.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import Foundation
import SwiftData

@MainActor
struct PreviewSampleData {
    static var container: ModelContainer = {
        do {
            let schema = Schema([Customer.self, Purchase.self, Item.self, Product.self])
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: schema, configurations: [configuration])
            
            let context = container.mainContext
            
            let sampleNames = [
                "João Silva", "Maria Oliveira", "Carlos Souza", "Ana Costa",
                "Pedro Santos", "Luciana Lima", "Marcos Pereira", "Fernanda Rocha",
                "Rafael Alves", "Patrícia Mendes"
            ]
            
            let sampleProducts = [
                Product(name: "Item 1", details: "300g", price: 1),
                Product(name: "Item 2", price: 2),
                Product(name: "Item 3", details: "Retornável", price: 3),
                Product(name: "Item 4", price: 4),
                Product(name: "Item 5", price: 0.50),
                Product(name: "Item 6", price: 6),
                Product(name: "Item 7", details: "300ml", price: 7),
                Product(name: "Item 8", price: 8),
                Product(name: "Item 9", details: "Limão", price: 9),
                Product(name: "Item 10", price: 10.10),
                Product(name: "Item 11", price: 11),
                Product(name: "Item 12", price: 12),
            ]
            
            for (index, name) in sampleNames.enumerated() {
                let phone = String(format: "(11) 9%04d-%04d", Int.random(in: 1000...9999), Int.random(in: 1000...9999))
                let customer = Customer(phoneNumber: phone, name: name)
                context.insert(customer)
                
                for _ in 0..<5 {
                    let purchase = Purchase(date: Date().addingTimeInterval(TimeInterval(-Int.random(in: 1...100) * 86400)), customer: customer, isPaid: Bool.random())
                    
                    let itemCount = Int.random(in: 3...20)
                    for _ in 0..<itemCount {
                        let product = sampleProducts.randomElement()!
                        
                        if let existingItemIndex = purchase.items.firstIndex(where: { $0.product == product }) {
                            purchase.items[existingItemIndex].quantity += 1
                        } else {
                            let quantity = Int.random(in: 1...5)
                            _ = Item(product: product, quantity: quantity, purchase: purchase)
                        }
                    }
                }
            }
            
            return container
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }()
}
