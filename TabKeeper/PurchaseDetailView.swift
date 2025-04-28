//
//  PurchaseDetailView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import SwiftData
import SwiftUI

struct PurchaseDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var purchase: Purchase
    
    @Binding var path: NavigationPath
    
    @State var newItemName = ""
    
    var body: some View {
        List {
            Section("Total") {
                HStack {
                    Text("\(purchase.totalQuantity) itens") // FIXME: item count not updating on delete
                    
                    Spacer()
                    
                    Text(purchase.totalPrice, format: .currency(code: "BRL"))
                }
            }
            
            Section {
                Toggle("Pago", isOn: $purchase.isPaid)
                
                #warning("Not implemented")
                if purchase.isPaid {
                    DatePicker("Data de pagamento", selection: .constant(.now), displayedComponents: .date)
                }
            }
            
            if !purchase.isPaid {
                Section {
                    HStack {
                        TextField("Novo item", text: $newItemName, axis: .vertical)
                        Button {
                            #warning("Not implemented")
                            newItemName = ""
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            
            ForEach($purchase.items) { $item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .bold()
                        
                        HStack {
                            Stepper("\(item.quantity)", value: $item.quantity, in: 1...99)
                                .labelsHidden()
                                .sensoryFeedback(trigger: item.quantity) { oldValue, newValue in
                                    return newValue > oldValue ? .increase : .decrease
                                }
                            
                            Text(item.quantity, format: .number)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(item.quantity) x \(item.price, format: .currency(code: "BRL"))") // FIXME: times symbol
                            .font(.caption)
                        Text(item.totalPrice, format: .currency(code: "BRL"))
                            .bold()
                    }
                }
            }
            .onDelete(perform: deleteItem)
        }
        .navigationTitle(Text(purchase.date, format: .dateTime.day().month().year()))
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: purchase.isPaid)
        .toolbar {
            Button("Compartilhar", systemImage: "square.and.arrow.up") {
                #warning("Not implemented")
            }
        }
    }
    
    func deleteItem(_ indexSet: IndexSet) {
        for index in indexSet {
            let item = purchase.items[index]
            #warning("Confirm approach")
            purchase.items.remove(at: index)
            modelContext.delete(item)
        }
    }
}

#Preview {
    let context = PreviewSampleData.container.mainContext
    let purchase = try! context.fetch(FetchDescriptor<Purchase>()).first!
    
    NavigationStack {
        PurchaseDetailView(purchase: purchase, path: .constant(NavigationPath()))
    }
}
