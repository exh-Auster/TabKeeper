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
    
    @State var showingNewItemScreen = false
    @State var newItemName = ""
    
    @State var showingEditDateScreen = false
    @State var editPurchaseDate = Date.now
    
    var body: some View {
        List {
            Section("Total") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(purchase.items.count) produtos") // FIXME: item count not updating on delete
                        Text("\(purchase.totalQuantity) itens") // FIXME: item count not updating on delete
                    }
                    
                    Spacer()
                    
                    Text(purchase.totalPrice, format: .currency(code: "BRL"))
                }
            }
            .onLongPressGesture(minimumDuration: 2, maximumDistance: 10) {
                // TODO: move to an appropriate location
                showingEditDateScreen = true
            }
            
            Section {
                TextField("Notas", text: $purchase.comment)
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
                    Button("Adicionar Item") {
                        showingNewItemScreen = true
                    }
                }
            }
            
            ForEach($purchase.items.reversed()) { $item in // FIXME: deletion
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.product.name)
                            .bold()
//                        Text(item.product.id.uuidString)
                        if !item.product.details.isEmpty {
                            Text(item.product.details)
                        }
                            
                        if !purchase.isPaid {
                            HStack {
                                Stepper("\(item.quantity)", value: $item.quantity, in: 1...99)
                                    .labelsHidden()
                                    .sensoryFeedback(trigger: item.quantity) { oldValue, newValue in
                                        return newValue > oldValue ? .increase : .decrease
                                    }
                                
                                Text(item.quantity, format: .number)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(item.quantity) x \(item.unitPrice, format: .currency(code: "BRL"))") // FIXME: times symbol
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
        .animation(.default, value: purchase.isPaid) // TODO: improve animation
        .toolbar {
            Button("Compartilhar", systemImage: "square.and.arrow.up") {
                #warning("Not implemented")
            }
        }
        .sheet(isPresented: $showingNewItemScreen) {
            NavigationStack {
                AddItemView(purchase: purchase)
            }
        }
        .sheet(isPresented: $showingEditDateScreen) {
            NavigationStack {
                Form {
                    DatePicker("Data da Compra", selection: $editPurchaseDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
                .presentationDetents([.fraction(0.6)])
                .navigationTitle("Data da Compra")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Salvar") {
                            purchase.date = editPurchaseDate
                            showingEditDateScreen = false
                        }
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") {
                            showingEditDateScreen = false
                        }
                    }
                }
            }
        }
        .onAppear {
            editPurchaseDate = purchase.date
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
