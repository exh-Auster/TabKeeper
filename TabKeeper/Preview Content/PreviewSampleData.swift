//
//  PreviewSampleData.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import Foundation
import SwiftData

@MainActor
class PreviewSampleData {
    static let shared = PreviewSampleData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    var customer: Customer {
        Customer.sampleData.first!
    }
    
    var product: Product {
        Product.sampleData.first!
    }
    
    var purchase: Purchase {
        Purchase.sampleData.first!
    }
    
    private init() {
        let schema = Schema([
            Customer.self,
            Item.self,
            Product.self,
            Purchase.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertSampleData()
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insertSampleData() {
        for customer in Customer.sampleData {
            context.insert(customer)
        }
        
        for product in Product.sampleData {
            context.insert(product)
        }
        
        for purchase in Purchase.sampleData {
            context.insert(purchase)
        }
    }
}
