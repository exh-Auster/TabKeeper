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
    
    @State var newCustomerName = ""
    @State var newCustomerPhoneNumber = ""
    
    @State var showingNewCustomerAlert = false
    
    @State var path = NavigationPath()
    @State var searchQuery = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if customers.isEmpty {
                    ContentUnavailableView(
                        "Nenhum Cliente Encontrado",
                        systemImage: "cube.box",
                        description: Text("Adicione seu primeiro cliente tocando no botão de \"+\" acima.")
                    )
                    //                    } else if customers.filter({ $0.name.localizedStandardContains(searchQuery) }).isEmpty {
                    //                        ContentUnavailableView.search
                } else {
                    ForEach(searchQuery.isEmpty // TODO: move
                            ? customers
                            : customers.filter { $0.name.localizedStandardContains(searchQuery) }) { customer in
                        NavigationLink(value: customer) {
                            VStack(alignment: .leading) {
                                Text(customer.name)
                                    .bold()
                                Text("\(customer.totalDebt, format: .currency(code: "BRL"))")
                            }
                            .contextMenu {
                                NavigationLink {
                                    EditCustomerView(existingCustomer: customer)
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                            } preview: {
                                CustomerDetailView(customer: customer, path: $path)
                                    .navigationBarTitleDisplayMode(.large)
                            }
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
                        }
                    }
                
                Button("Cancelar", role: .cancel) {
                    newCustomerName = ""
                    newCustomerPhoneNumber = ""
                }
                
                Button("OK") {
                    let newCustomer = Customer(phoneNumber: newCustomerPhoneNumber, name: newCustomerName)
                    modelContext.insert(newCustomer)
                    path.append(newCustomer)
                    
                    newCustomerName = ""
                    newCustomerPhoneNumber = ""
                }
                .disabled(newCustomerName.isEmpty)
                .disabled(newCustomerPhoneNumber.count > 0 && newCustomerPhoneNumber.count < 11 )
                
                // TODO:
            }
        }
    }
    
    func deleteAllData() {
        do {
            let customers = try modelContext.fetch(FetchDescriptor<Customer>())
            let purchases = try modelContext.fetch(FetchDescriptor<Purchase>())
            let items     = try modelContext.fetch(FetchDescriptor<Item>())
            let products  = try modelContext.fetch(FetchDescriptor<Product>())

            for customer in customers {
                modelContext.delete(customer)
            }
            for purchase in purchases {
                modelContext.delete(purchase)
            }
            for item in items {
                modelContext.delete(item)
            }
            for product in products {
                modelContext.delete(product)
            }

            try modelContext.save()
        } catch {
            print("Error wiping data: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.container)
}
