//
//  EditProductView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 29/04/25.
//

import SwiftUI

struct EditProductView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    var existingProduct: Product?

    @State private var name: String
    @State private var details: String
    @State private var price: Decimal
    
    init(existingProduct: Product? = nil) {
        self.existingProduct = existingProduct
        
        self.name = ""
        self.details = ""
        self.price = Decimal(0)
    }
    
    init(name: String) {
        self.name = name
        self.details = ""
        self.price = Decimal(0)
    }

    var body: some View {
        Form {
            TextField("Nome", text: $name)
            TextField("Tipo", text: $details)
            TextField("Preço", value: $price, format: .currency(code: "BRL"))
        }
        .navigationTitle(existingProduct == nil ? "Novo Produto" : "Editar Produto")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Salvar") {
                    if let product = existingProduct {
                        product.name = name
                        product.details = details
                        product.price = price
                    } else {
                        let newProduct = Product(name: name, details: details, price: price)
                        modelContext.insert(newProduct)
                    }
                    
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if let product = existingProduct {
                name = product.name
                details = product.details
                price = product.price
            }
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    
    NavigationStack {
        NavigationLink("X", value: Product(name: "Test", price: 10))
            .navigationDestination(for: Product.self) { product in
                EditProductView(existingProduct: product)
            }
    }
}
