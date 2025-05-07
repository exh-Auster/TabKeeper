//
//  EditCustomerView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 30/04/25.
//

import Combine
import SwiftUI

struct EditCustomerView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    private var existingCustomer: Customer?
    
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
                .textContentType(.name)
            TextField("Telefone", text: $phoneNumber)
                .keyboardType(.numberPad)
                .textContentType(.telephoneNumber)
                .onReceive(Just(phoneNumber)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.phoneNumber = filtered
                    } // TODO: extract
                }
        }
        .navigationTitle(existingCustomer == nil ? "Novo Cliente" : "Editar Cliente")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Salvar") {
                    saveCustomer()
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
        }
        .onAppear {
            loadCustomer()
        }
    }
    
    private func loadCustomer() {
        if let customer = existingCustomer {
            name = customer.name
            phoneNumber = customer.phoneNumber
        }
    }
    
    private func saveCustomer() {
        if let customer = existingCustomer {
            customer.name = name
            customer.phoneNumber = phoneNumber
        } else {
            let newCustomer = Customer(phoneNumber: phoneNumber, name: name)
            modelContext.insert(newCustomer)
        }
    }
}

#Preview {
    NavigationStack {
        EditCustomerView()
    }
}
