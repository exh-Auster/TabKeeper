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
    
    @State private var isShowingEditSheet = false
    
    var body: some View {
        NavigationStack {
            List(products) { product in
                NavigationLink(value: product) {
                    ProductRowView(product: product)
                }
            }
            .navigationTitle("Produtos")
            .navigationDestination(for: Product.self) { product in
                ProductView(product: product)
            }
        }
    }
}

#Preview {
    InventoryView()
        .modelContainer(PreviewSampleData.shared.modelContainer)
}
