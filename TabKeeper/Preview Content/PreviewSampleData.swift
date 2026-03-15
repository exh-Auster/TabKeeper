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
    
    var customerWithEmptyHistory: Customer {
        Customer.sampleData.first!
    }
    
    var customerWithPaidHistory: Customer {
        Customer.sampleData.first {
            let purchases = $0.purchases!
            return !purchases.isEmpty && purchases.allSatisfy { $0.isPaid }
        }!
    }
    
    var customerWithPendingHistory: Customer {
        Customer.sampleData.first {
            let purchases = $0.purchases!
            return !purchases.isEmpty && purchases.allSatisfy { !$0.isPaid }
        }!
    }
    
    var customerWithFullHistory: Customer {
        Customer.sampleData.first {
            let purchases = $0.purchases!
            return purchases.contains { $0.isPaid } && purchases.contains { !$0.isPaid }
        }!
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
