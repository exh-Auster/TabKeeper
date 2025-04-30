//
//  ContentView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var customers: [Customer] // TODO: order by debt / recent
    
    @State var newCustomerName = ""
    @State var newCustomerPhoneNumber = ""
    
    @State var showingNewCustomerAlert = false
    
    @State var path = NavigationPath()
    @State var searchQuery = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(searchQuery.isEmpty // TODO: move
                        ? customers
                        : customers.filter { $0.name.localizedStandardContains(searchQuery) }) { customer in
                    NavigationLink(value: customer) {
                        VStack(alignment: .leading) {
                            Text(customer.name)
                                .bold()
                            Text("Devendo \(customer.totalDebt, format: .currency(code: "BRL"))")
                        }
                    }
                }
            }
            .navigationTitle("Clientes")
            .navigationDestination(for: Customer.self, destination: { customer in
                CustomerDetailView(customer: customer, path: $path)
            })
            .searchable(
                text: $searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Pesquisar"
            )
            .toolbar {
                Button("Adicionar Cliente", systemImage: "plus") {
                    showingNewCustomerAlert = true
                }
            }
            .alert("Novo Cliente", isPresented: $showingNewCustomerAlert) {
                TextField("Nome", text: $newCustomerName)
                TextField("Telefone (opcional)", text: $newCustomerPhoneNumber)
                
                Button("Cancelar", role: .cancel) { }
                Button("OK") {
                    let newCustomer = Customer(phoneNumber: newCustomerPhoneNumber, name: newCustomerName)
                    modelContext.insert(newCustomer)
                    path.append(newCustomer)
                    
                    newCustomerName = ""
                    newCustomerPhoneNumber = ""
                }
                .disabled(newCustomerName.isEmpty)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.container)
}
