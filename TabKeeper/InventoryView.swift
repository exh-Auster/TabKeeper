//
//  InventoryView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 10/05/25.
//

import SwiftData
import SwiftUI

struct InventoryView: View {
    @Query var products: [Product]
    
    @State private var searchQuery = ""
    @State private var isShowingEditSheet = false
    
    private var filteredProducts: [Product] {
        guard !searchQuery.isEmpty else { return products }
        
        return products.filter { product in
            [product.name, product.brand, product.details]
                .contains { $0.localizedStandardContains(searchQuery) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if products.isEmpty { // TODO: search
                    ContentUnavailableView {
                        Label("Sem produtos", systemImage: "tray")
                    } description: {
                        Text("Seus produtos aparecerão aqui.")
                    }
                } else {
                    if !searchQuery.isEmpty && filteredProducts.isEmpty {
                        ContentUnavailableView.search
                    } else {
                        ForEach(filteredProducts) { product in
                            NavigationLink(value: product) {
                                ProductRowView(product: product)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Produtos")
            .navigationDestination(for: Product.self) { product in
                ProductView(product: product)
            }
            .searchable(text: $searchQuery)
        }
    }
}

#Preview("Filled") {
    InventoryView()
        .modelContainer(PreviewSampleData.shared.modelContainer)
}

#Preview("Empty") {
    InventoryView()
}
