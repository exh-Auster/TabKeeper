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
                    Text("\(purchase.items.count) itens") // FIXME: count * quantity
                    
                    Spacer()
                    
                    Text(grandTotal, format: .currency(code: "BRL"))
                }
            }
            
            Section {
                Button("Adicionar item") {
                    #warning("Not implemented")
                }
            }
            
            ForEach($purchase.items) { $item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .bold()
                        
                        HStack {
                            Stepper("\(item.quantity)", value: $item.quantity, in: 1...99)
                                .labelsHidden()
                                .sensoryFeedback(trigger: item.quantity) { oldValue, newValue in
                                    return newValue > oldValue ? .increase : .decrease
                                }
                            
                            Text(item.quantity, format: .number)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(item.quantity) x \(item.price, format: .currency(code: "BRL"))") // FIXME: times symbol
                            .font(.caption)
                        Text(Decimal(item.quantity) * item.price, format: .currency(code: "BRL"))
                            .bold()
                    }
                }
            }
            .onDelete { _ in
                #warning("Not implemented")
            }
        }
        .navigationTitle(Text(purchase.date, format: .dateTime.day().month().year()))
        .navigationBarTitleDisplayMode(.inline)
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
    
    NavigationStack {
        PurchaseDetailView(purchase: purchase)
    }
}
