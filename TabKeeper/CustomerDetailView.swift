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
    
    @Binding var path: NavigationPath
    
    var body: some View {
        List { // TODO: extract view
            Section("Em aberto") {
                ForEach(customer.purchases.filter({ !$0.isPaid })) { purchase in
                    NavigationLink(value: purchase) {
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
            
            Section("Pagas") {
                ForEach(customer.purchases.filter({ $0.isPaid })) { purchase in
                    NavigationLink(value: purchase) {
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
        .navigationTitle($customer.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Purchase.self, destination: { purchase in
            PurchaseDetailView(purchase: purchase, path: $path)
        })
        .toolbar {
            Button("Adicionar Compra", systemImage: "plus") {
                let newPurchase = Purchase(customer: customer)
                modelContext.insert(newPurchase)
                path.append(newPurchase)
            }
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
        CustomerDetailView(customer: customer, path: .constant(NavigationPath()))
            .modelContainer(PreviewSampleData.container)
    }
}
