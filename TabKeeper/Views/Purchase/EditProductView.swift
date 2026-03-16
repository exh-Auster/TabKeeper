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
    @State private var brand: String
    @State private var details: String
    @State private var price: Decimal
    
    init(existingProduct: Product? = nil) {
        self.existingProduct = existingProduct
        
        self.name = ""
        self.brand = ""
        self.details = ""
        self.price = Decimal(0)
    }
    
    init(name: String) {
        self.name = name
        self.brand = ""
        self.details = ""
        self.price = Decimal(0)
    }

    var body: some View {
        Form {
            TextField("Nome", text: $name)
                .textInputAutocapitalization(.words)
            TextField("Marca (opcional)", text: $brand)
                .textInputAutocapitalization(.words)
            TextField("Tipo (opcional)", text: $details)
                .textInputAutocapitalization(.words)
            TextField("Preço", value: $price, format: .currency(code: "BRL")) // TODO: locale
                .keyboardType(.decimalPad)
        }
        .navigationTitle(existingProduct == nil ? "Novo Produto" : "Editar Produto")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar", role: .cancel) { dismiss() }
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
            brand = product.brand
            details = product.details
            price = product.price
        }
    }
    
    func saveProduct() {
        if let product = existingProduct {
            product.name = name
            product.brand = brand
            product.details = details
            product.price = price
        } else {
            let newProduct = Product(name: name, brand: brand, details: details, price: price)
            modelContext.insert(newProduct)
        }
    }
}

#Preview {
    let product = PreviewSampleData.shared.product
    
    EditProductView(existingProduct: product)
}

#Preview("In NavigationStack") {
    let product = PreviewSampleData.shared.product
    
    NavigationStack {
        List {
            Text("EditProductView preview")
                .navigationDestination(isPresented: .constant(true)) {
                    EditProductView(existingProduct: product)
                }
        }
    }
}
