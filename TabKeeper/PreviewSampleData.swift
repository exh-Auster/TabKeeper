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
            let schema = Schema([Customer.self, Purchase.self, Item.self])
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: schema, configurations: [configuration])
            
            let context = container.mainContext
            
            let sampleNames = [
                "João Silva", "Maria Oliveira", "Carlos Souza", "Ana Costa",
                "Pedro Santos", "Luciana Lima", "Marcos Pereira", "Fernanda Rocha",
                "Rafael Alves", "Patrícia Mendes"
            ]
            
            let sampleItems = [
                "Arroz", "Feijão", "Macarrão", "Óleo", "Sal", "Açúcar", "Café",
                "Farinha", "Leite", "Biscoito", "Margarina", "Pão", "Sabonete",
                "Shampoo", "Detergente", "Fralda", "Cerveja", "Refrigerante",
                "Suco", "Chocolate"
            ]
            
            for (index, name) in sampleNames.enumerated() {
                let phone = String(format: "(11) 9%04d-%04d", Int.random(in: 1000...9999), Int.random(in: 1000...9999))
                let customer = Customer(phoneNumber: phone, name: name)
                context.insert(customer)
                
                for _ in 0..<3 {
                    let purchase = Purchase(customer: customer, isPaid: Bool.random())
                    
                    let itemCount = Int.random(in: 3...20)
                    for _ in 0..<itemCount {
                        let itemName = sampleItems.randomElement()!
                        let price = Decimal(Double.random(in: 2...50))
                        let quantity = Int.random(in: 1...5)
                        _ = Item(name: itemName, price: price, quantity: quantity, purchase: purchase)
                    }
                }
            }
            
            return container
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }()
}
