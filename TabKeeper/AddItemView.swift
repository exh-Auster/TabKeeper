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
    
    @State var showingSearch = true
    @State var searchQuery = ""
    
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
                    ForEach(filteredProducts, id: \.product.id) { i in
                        Button {
                            if let existingItemIndex = purchase.items.firstIndex(where: { $0.product == i.product }) {
                                purchase.items[existingItemIndex].quantity += 1
                            } else {
                                let newItem = Item(product: i.product, quantity: 1)
                                purchase.items.append(newItem)
                            }
                            
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(i.product.name)
//                                        .bold()

                                    if !i.product.details.isEmpty {
                                        Text(i.product.details)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Text(i.product.price, format: .currency(code: "BRL"))
                            }
//                            .frame(minHeight: 44)
                            .contextMenu {
                                NavigationLink(value: i.product) {
                                    Label("Editar", systemImage: "pencil")
                                }
                            }
                        }
                    }
                }
            } else if !isLoading && !allProducts.isEmpty {
                Section {
                    ContentUnavailableView(
                        "Produto não encontrado",
                        systemImage: "magnifyingglass",
                        description: Text("Tente pesquisar com outro termo ou crie um novo produto.")
                    )
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
    
    func getAllProductsSortedByPurchaseCount(context: ModelContext) async throws -> [(product: Product, count: Int)] {
        let productDescriptor = FetchDescriptor<Product>()
        let allProducts = try context.fetch(productDescriptor)
        
        let itemDescriptor = FetchDescriptor<Item>()
        let allItems = try context.fetch(itemDescriptor)
        
        var productCounts: [UUID: Int] = [:]
        
        for product in allProducts {
            productCounts[product.id] = 0
        }
        
        for item in allItems {
            let productId = item.product.id
            productCounts[productId, default: 0] += item.quantity
        }
        
        var result: [(product: Product, count: Int)] = []
        
        for product in allProducts {
            let count = productCounts[product.id] ?? 0
            result.append((product: product, count: count))
        }
        
        result.sort { $0.count > $1.count }
        
        return result
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
