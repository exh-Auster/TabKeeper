//
//  ContentView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Query var customers: [Customer]
    
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
                            Text(customer.phoneNumber)
                                .font(.caption)
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
