//
//  CustomerRowView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 08/05/25.
//

import SwiftData
import SwiftUI

struct CustomerRowView: View {
    let customer: Customer
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationLink(value: customer) {
            VStack(alignment: .leading) {
                Text(customer.name)
                    .bold()
                Text("\(customer.totalDebt, format: .currency(code: "BRL"))") // TODO: locale
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

#Preview {
    let context = PreviewSampleData.container.mainContext
    let customer = try! context.fetch(FetchDescriptor<Customer>()).first!
    
    NavigationStack {
        List {
            CustomerRowView(customer: customer, path: .constant(NavigationPath()))
            CustomerRowView(customer: Customer(phoneNumber: "", name: "CustomerRowView Preview"), path: .constant(NavigationPath()))
        }
    }
}
