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
        }
//        .frame(minHeight: 44)
        .contextMenu {
            NavigationLink(value: product) {
                Label("Editar", systemImage: "pencil")
            }
        }
    }
}

#Preview {
    let context = PreviewSampleData.container.mainContext
    let product = try! context.fetch(FetchDescriptor<Product>()).first(where: { !$0.details.isEmpty })!
    
    List {
        ProductRowView(product: product)
    }
}
