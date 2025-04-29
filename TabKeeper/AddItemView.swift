//
//  AddItemView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 28/04/25.
//

import SwiftData
import SwiftUI

struct AddItemView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var purchase: Purchase
    
    @Query(sort: \Purchase.date, order: .reverse) var purchases: [Purchase]
    @Query var products: [Product]
    
    @State var showingSearch = true
    @State var searchQuery = ""
    
    var numberOfLatestPurchases = 100
    
    var body: some View {
        let latestPurchases = purchases.prefix(numberOfLatestPurchases)
        
        let productCounts = latestPurchases
            .flatMap { $0.items }
            .reduce(into: [:]) { counts, item in
                counts[item.product, default: 0] += item.quantity
            }
        
        let filteredProducts = productCounts
            .sorted { $0.value > $1.value }
            .filter {
                searchQuery.isEmpty
                ? true
                : $0.key.name.localizedStandardContains(searchQuery)
                || $0.key.details.localizedStandardContains(searchQuery)
            }
        
        List {
            Section {
                NavigationLink("Novo Item") {
                    EditProductView(name: searchQuery)
                }
            }
            if !filteredProducts.isEmpty {
                Section("Mais frequentes") {
//                    ForEach(filteredProducts, id: \.key.id) { product, count in
                    ForEach(products) { product in
                        Button {
                            if let existingItemIndex = purchase.items.firstIndex(where: { $0.product == product }) {
                                purchase.items[existingItemIndex].quantity += 1
                            } else {
                                let newItem = Item(product: product, quantity: 1)
                                purchase.items.append(newItem)
                            }
                            
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(product.name)
//                                        .bold()

                                    if !product.details.isEmpty {
                                        Text(product.details)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Text(product.price, format: .currency(code: "BRL"))
                            }
//                            .frame(minHeight: 44)
                            .contextMenu {
                                NavigationLink("Editar", value: product)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Adicionar Produto")
        .navigationDestination(for: Product.self) { product in
            EditProductView(existingProduct: product)
        }
        .searchable(text: $searchQuery, isPresented: $showingSearch)
        .toolbar {
            ToolbarItemGroup {
                Button("Cancelar", role: .cancel) {
                    dismiss()
                }
            }
        }
//        .listStyle(.inset)
    }
}

#Preview {
    Text("Text")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                AddItemView(purchase: Purchase(customer: Customer(phoneNumber: "", name: "")))
            }
            .modelContainer(PreviewSampleData.container)
        }
}
