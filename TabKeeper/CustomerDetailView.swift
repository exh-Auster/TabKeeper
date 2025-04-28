//
//  CustomerDetailView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import SwiftData
import SwiftUI

struct CustomerDetailView: View {
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
                                Text(purchase.date, format: .dateTime)
                                Text("PLACEHOLDER") // TODO: value
                            }
                            
                            Spacer()
                            
                            Image(systemName: purchase.isPaid ? "checkmark.circle.fill" : "x.circle")
                        }
                    }
                }
                .onDelete { _ in
                    #warning("Not implemented")
                }
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
}

#Preview {
    let context = PreviewSampleData.container.mainContext
    let customer = try! context.fetch(FetchDescriptor<Customer>()).first!

    NavigationStack {
        CustomerDetailView(customer: customer)
            .modelContainer(PreviewSampleData.container)
    }
}
