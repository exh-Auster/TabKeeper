//
//  CustomerDetailView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import SwiftData
import SwiftUI

struct CustomerDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var customer: Customer
    
    var body: some View {
        List {
            Section("Compras") {
                ForEach(customer.purchases) { purchase in
                    NavigationLink {
                        PurchaseDetailView(purchase: purchase)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(purchase.date.formatted(date: .numeric, time: .omitted))
                                    .bold()
                                
                                Text(purchase.totalPrice, format: .currency(code: "BRL"))
                            }
                            
                            Spacer()
                            
                            Image(systemName: purchase.isPaid ? "checkmark.circle.fill" : "x.circle")
                                .foregroundStyle(purchase.isPaid ? .green : .red)
                        }
                    }
                }
                .onDelete(perform: deletePurchase)
            }
        }
        .navigationTitle(customer.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Adicionar Compra", systemImage: "plus") {
                #warning("Not implemented")
            }
            .disabled(true)
        }
    }
    
    func deletePurchase(_ indexSet: IndexSet) {
        for index in indexSet {
            let purchase = customer.purchases[index]
            modelContext.delete(purchase)
        }
    }
}

#Preview {
    let context = PreviewSampleData.container.mainContext
    let customer = try! context.fetch(FetchDescriptor<Customer>()).first!

    NavigationStack {
        CustomerDetailView(customer: customer)
            .modelContainer(PreviewSampleData.container)
    }
}
