//
//  EditCustomerView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 30/04/25.
//

import SwiftUI

struct EditCustomerView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var existingCustomer: Customer?
    
    @State private var name: String
    @State private var phoneNumber: String
    
    init(existingCustomer: Customer? = nil) {
        self.existingCustomer = existingCustomer
        
        self.name = ""
        self.phoneNumber = ""
    }
    
    var body: some View {
        Form {
            TextField("Nome", text: $name)
            TextField("Telefone", text: $phoneNumber)
        }
        .navigationTitle(existingCustomer == nil ? "Novo Cliente" : "Editar Cliente")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Salvar") {
                    if let customer = existingCustomer {
                        customer.name = name
                        customer.phoneNumber = phoneNumber
                    } else {
                        let newCustomer = Customer(phoneNumber: phoneNumber, name: name)
                        modelContext.insert(newCustomer)
                    }
                    
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
        }
        .onAppear {
            if let customer = existingCustomer {
                name = customer.name
                phoneNumber = customer.phoneNumber
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        EditCustomerView()
    }
}
