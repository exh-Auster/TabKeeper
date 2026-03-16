//
//  ProductView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 15/03/26.
//

import SwiftUI

struct ProductView: View {
    let product: Product
    var lastSalesLimit: Int? = nil
    
    @State private var isShowingOnlyUnpaid = false
    
    private var purchases: [Purchase] {
        let sorted = product.item?.compactMap { $0.purchase }
            .filter({ isShowingOnlyUnpaid ? !$0.isPaid : true })
            .sorted { $0.date > $1.date } ?? []
        
        if let lastSalesLimit {
            return Array(sorted.prefix(lastSalesLimit))
        }
        
        return sorted
    }
    
    var body: some View {
        List {
            Section("Últimas vendas") {
                Picker("Tipo de venda", selection: $isShowingOnlyUnpaid) {
                    Text("Todas")
                        .tag(false)
                    Text("Não pagas")
                        .tag(true)
                }
                .pickerStyle(.segmented)
                
                ForEach(purchases) { purchase in
                    NavigationLink {
                        PurchaseDetailView(purchase: purchase, path: .constant(NavigationPath()))
                    } label: {
                        PurchaseRowView(purchase: purchase, showCustomerName: true)
                    }
                }
            }
        }
        .navigationTitle(product.name)
        .navigationSubtitle(product.details)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    let product = PreviewSampleData.shared.product
    
    NavigationStack {
        ProductView(product: product)
    }
}
