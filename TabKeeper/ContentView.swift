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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(customers) { customer in
                    NavigationLink {
                        CustomerDetailView(customer: customer)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(customer.name)
                                .bold()
                            Text("Devendo \(customer.totalDebt, format: .currency(code: "BRL"))")
                        }
                    }
                }
            }
            .navigationTitle("Clientes")
            .toolbar {
                Button("Adicionar Cliente", systemImage: "plus") {
                    #warning("Not implemented")
                }
                .disabled(true)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.container)
}
