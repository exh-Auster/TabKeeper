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

    private var existingProduct: Product?

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
                .textInputAutocapitalization(.words)
            TextField("Tipo", text: $details)
                .textInputAutocapitalization(.words)
            TextField("Preço", value: $price, format: .currency(code: "BRL")) // TODO: locale
                .keyboardType(.decimalPad)
        }
        .navigationTitle(existingProduct == nil ? "Novo Produto" : "Editar Produto")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Salvar") {
                    saveProduct()
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadProduct()
        }
    }
    
    func loadProduct() {
        if let product = existingProduct {
            name = product.name
            details = product.details
            price = product.price
        }
    }
    
    func saveProduct() {
        if let product = existingProduct {
            product.name = name
            product.details = details
            product.price = price
        } else {
            let newProduct = Product(name: name, details: details, price: price)
            modelContext.insert(newProduct)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    
    NavigationStack {
        NavigationLink("EditProductView Preview", value: Product(name: "EditProductView Preview", price: 10))
            .navigationDestination(for: Product.self) { product in
                EditProductView(existingProduct: product)
            }
    }
}
