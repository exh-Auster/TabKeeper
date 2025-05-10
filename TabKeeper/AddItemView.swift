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
    
    @State private var showingSearch = true
    @State private var searchQuery = ""
    
    @State private var allProducts: [(product: Product, count: Int)] = []
    @State private var isLoading = true
    
    var body: some View {
        List {
            Section {
                NavigationLink("Novo Produto") {
                    EditProductView(name: searchQuery)
                }
            }
            
            if !filteredProducts.isEmpty {
                Section("Mais frequentes") {
                    ForEach(filteredProducts, id: \.product.id) { filteredProduct in
                        Button {
                            addProduct(product: filteredProduct.product)
                            dismiss()
                        } label: {
                            ProductRowView(product: filteredProduct.product)
                        }
                    }
                }
            } else if !isLoading && !allProducts.isEmpty {
                Section {
                    ContentUnavailableView.search
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
        .task {
            await loadProducts()
        }
        .refreshable {
            await loadProducts()
        }
    }
    
    private var filteredProducts: [(product: Product, count: Int)] {
        if searchQuery.isEmpty {
            return allProducts
        } else {
            return allProducts.filter { item in
                item.product.name.localizedCaseInsensitiveContains(searchQuery) ||
                item.product.details.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    private func loadProducts() async {
        isLoading = true
        
        do {
            allProducts = try await getAllProductsSortedByPurchaseCount(context: modelContext)
            isLoading = false
        } catch {
            print("Error loading products: \(error)")
            isLoading = false
        }
    }
    
    private func getAllProductsSortedByPurchaseCount(context: ModelContext) async throws -> [(product: Product, count: Int)] {
        let productDescriptor = FetchDescriptor<Product>()
        let allProducts = try context.fetch(productDescriptor)

        var result: [(product: Product, count: Int)] = []
        
        for product in allProducts {
            let productId = product.id
            
            let itemDescriptor = FetchDescriptor<Item>(
                predicate: #Predicate<Item> { item in
                    item.product.id == productId
                }
            )
            
            let itemCount = try context.fetchCount(itemDescriptor)
            result.append((product: product, count: itemCount))
        }
        
        result.sort { $0.count > $1.count }
        
        return result
    }
    
    private func addProduct(product: Product) {
        if let existingItemIndex = purchase.items.firstIndex(where: { $0.product == product }) {
            purchase.items[existingItemIndex].quantity += 1
        } else {
            let newItem = Item(product: product, quantity: 1)
            purchase.items.append(newItem)
        }
    }
}

#Preview {
    Text("AddItemView Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                AddItemView(purchase: Purchase(customer: Customer(phoneNumber: "", name: "AddItemView Preview")))
            }
            .modelContainer(PreviewSampleData.container)
        }
}
