//
//  ContentView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import Combine
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var customers: [Customer] // TODO: order by debt / recent
    
    @State private var newCustomerName = ""
    @State private var newCustomerPhoneNumber = ""
    
    @State private var showingNewCustomerAlert = false
    
    @State private var path = NavigationPath()
    @State private var showingSearch = false
    @State private var searchQuery = ""
    
    private var filteredCustomers: [Customer] {
        searchQuery.isEmpty
            ? customers
            : customers.filter { $0.name.localizedStandardContains(searchQuery) }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if customers.isEmpty {
                    ContentUnavailableView(
                        "Nenhum Cliente Encontrado",
                        systemImage: "cube.box",
                        description: Text("Adicione seu primeiro cliente tocando no botão de \"+\" acima.")
                    )
                } else if !searchQuery.isEmpty && filteredCustomers.isEmpty {
                    ContentUnavailableView.search
                } else {
                    ForEach(filteredCustomers) { customer in
                        CustomerRowView(customer: customer, path: $path)
                    }
                }
            }
            .navigationTitle("Clientes")
            .navigationDestination(for: Customer.self, destination: { customer in
                CustomerDetailView(customer: customer, path: $path)
            })
            .animation(.default, value: customers)
            .animation(.default, value: showingSearch)
            .searchable(
                text: $searchQuery,
                isPresented: $showingSearch,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset", systemImage: "trash", role: .destructive) {
                        deleteAllData()
                    }
                }
                
                ToolbarItem {
                    Button("Adicionar Cliente", systemImage: "plus") {
                        showingNewCustomerAlert = true
                    }
                }
            }
            .alert("Novo Cliente", isPresented: $showingNewCustomerAlert) {
                TextField("Nome", text: $newCustomerName)
                    .textContentType(.name)
                TextField("Telefone (opcional)", text: $newCustomerPhoneNumber)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.numberPad)
                    .onReceive(Just(newCustomerPhoneNumber)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.newCustomerPhoneNumber = filtered
                        } // TODO: extract
                    }
                
                Button("Cancelar", role: .cancel) {
                    newCustomerName = ""
                    newCustomerPhoneNumber = ""
                }
                
                Button("OK") {
                    createCustomer()
                }
                .disabled(newCustomerName.isEmpty) // TODO: extract
                .disabled(newCustomerPhoneNumber.count > 0 && newCustomerPhoneNumber.count < 11 )
            }
        }
    }
    
    private func createCustomer() {
        let newCustomer = Customer(phoneNumber: newCustomerPhoneNumber, name: newCustomerName)
        modelContext.insert(newCustomer)
        path.append(newCustomer)
        
        newCustomerName = ""
        newCustomerPhoneNumber = ""
    }
    
    private func deleteAllData() {
        do {
            if modelContext.hasChanges { try modelContext.save() }
            
            try modelContext.delete(model: Customer.self)
            try modelContext.delete(model: Purchase.self)
            try modelContext.delete(model: Item.self)
            try modelContext.delete(model: Product.self)
        } catch {
            print("Error wiping data: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.container)
}
