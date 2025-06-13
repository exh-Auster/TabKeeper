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
    
    private var hasPurchases: Bool {
        !customer.purchases.isEmpty
    }
    
    private var unpaidPurchases: [Purchase] {
        customer.purchases.filter { !$0.isPaid }
    }
    
    private var paidPurchases: [Purchase] {
        customer.purchases.filter { $0.isPaid }
    }
    
    var body: some View {
        List { // TODO: extract view
            if !hasPurchases {
                ContentUnavailableView(
                    "Sem Histórico",
                    systemImage: "cube.box",
                    description: Text("Este cliente ainda não tem compras registradas.\n\nAdicione a primeira compra tocando no botão de \"+\" acima.")
                )
            } else {
                Section("Em aberto") {
                    if unpaidPurchases.isEmpty {
                        ContentUnavailableView(
                            "Cliente Em Dia",
                            systemImage: "person.crop.circle.badge.checkmark",
                            description: Text("Futuras compras em aberto deste cliente aparecerão aqui.")
                        )
                    } else {
                        ForEach(unpaidPurchases) { purchase in
                            NavigationLink(value: purchase) {
                                PurchaseRowView(purchase: purchase)
                            }
                        }
                        .onDelete { indexSet in
                            deletePurchase(from: unpaidPurchases, at: indexSet)
                        }
                    }
                }
                
                Section("Pagas") {
                    if paidPurchases.isEmpty {
                        ContentUnavailableView(
                            "Sem Histórico de Pagamento",
                            systemImage: "cube.box",
                            description: Text("O histórico de compras pagas deste cliente aparecerá aqui.")
                        )
                    } else {
                        ForEach(paidPurchases) { purchase in
                            NavigationLink(value: purchase) {
                                PurchaseRowView(purchase: purchase)
                            }
                        }
                        .onDelete { indexSet in
                            deletePurchase(from: paidPurchases, at: indexSet)
                        }
                    }
                }
            }
        }
        .animation(.bouncy, value: customer.purchases.count)
        .navigationTitle($customer.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Purchase.self, destination: { purchase in
            PurchaseDetailView(purchase: purchase, path: $path)
        })
        .toolbar {
            Button("Adicionar Compra", systemImage: "plus") {
                createPurchase()
            }
        }
    }
    
    func createPurchase() {
        let newPurchase = Purchase(customer: customer)
        modelContext.insert(newPurchase)
        path.append(newPurchase)
    }
    
    func deletePurchase(from filteredPurchases: [Purchase], at indexSet: IndexSet) {
        for index in indexSet {
            let purchase = filteredPurchases[index]
            modelContext.delete(purchase)
        }
        
        try? modelContext.save()
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
