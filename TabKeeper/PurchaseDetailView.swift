//
//  PurchaseDetailView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import SwiftData
import SwiftUI

struct PurchaseDetailView: View {
    @Bindable var purchase: Purchase
    
    var grandTotal: Decimal {
        purchase.items.reduce(Decimal(0)) { partialResult, item in
            partialResult + item.price
        }
    }
    
    var body: some View {
        List {
            Section("Total") {
                HStack {
                    Text("\(purchase.items.count) itens")
                    
                    Spacer()
                    
                    Text(grandTotal, format: .currency(code: "BRL"))
                }
            }
            
            ForEach(purchase.items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                        Text("\(item.quantity) x \(item.price, format: .currency(code: "BRL"))")
                    }
                    
                    Spacer()
                    
                    Text(Decimal(item.quantity) * item.price, format: .currency(code: "BRL"))
                }
            }
        }
        .toolbar {
            Button("Compartilhar", systemImage: "square.and.arrow.up") {
                #warning("Not implemented")
            }
        }
    }
}

#Preview {
    let context = PreviewSampleData.container.mainContext
    let purchase = try! context.fetch(FetchDescriptor<Purchase>()).first!
    
    PurchaseDetailView(purchase: purchase)
}
