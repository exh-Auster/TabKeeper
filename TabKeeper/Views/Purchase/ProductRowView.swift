//
//  ProductRowView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 10/05/25.
//

import SwiftData
import SwiftUI

struct ProductRowView: View {
    var product: Product
    
    var showEditIcon = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.name)
//                    .bold()

                if !product.details.isEmpty {
                    Text(product.details)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Text(product.price, format: .currency(code: "BRL")) // TODO: locale
            
            if showEditIcon {
                Button("Editar", systemImage: "pencil.circle") { }
                    .labelStyle(.iconOnly)
                    .tint(.accentColor)
            }
        }
//        .frame(minHeight: 44)
        .contextMenu {
            NavigationLink(value: product) {
                Label("Editar", systemImage: "pencil")
            }
        }
    }
}

#Preview("No edit icon") {
    let product = Product.sampleData.first { !$0.details.isEmpty }!
    
    ProductRowView(product: product)
}

#Preview("With edit icon") {
    let product = Product.sampleData.first { !$0.details.isEmpty }!
    
    ProductRowView(product: product, showEditIcon: true)
}

#Preview("In List, no edit icon") {
    let product = Product.sampleData.first { !$0.details.isEmpty }!
    
    ProductRowView(product: product)
}

#Preview("In List") {
    let product = Product.sampleData.first { !$0.details.isEmpty }!
    
    List {
        ProductRowView(product: product, showEditIcon: true)
    }
}

#Preview("In List, with edit icon") {
    let product = Product.sampleData.first { !$0.details.isEmpty }!
    
    List {
        ProductRowView(product: product, showEditIcon: true)
    }
}
