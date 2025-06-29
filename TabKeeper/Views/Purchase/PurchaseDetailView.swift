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
    
    @State private var showingNewItemScreen = false
    @State private var newItemName = ""
    
    @State private var showingEditDateScreen = false
    @State private var editPurchaseDate = Date.now
    
    var body: some View {
        List {
            Section("Total") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(purchase.items.count) produtos")
                        Text("\(purchase.totalQuantity) itens")
                    }
                    
                    Spacer()
                    
                    Text(purchase.totalPrice, format: .currency(code: "BRL")) // TODO: locale
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
                    .onChange(of: purchase.isPaid) { _, newValue in
                        if newValue == false { purchase.datePaid = nil }
                        else { purchase.datePaid = .now }
                    }
                
                if purchase.isPaid {
                    DatePicker("Data de pagamento", selection: Binding(
                        get: { purchase.datePaid ?? Date() },
                        set: { purchase.datePaid = $0 }
                    ), displayedComponents: .date)
                }
            }
            
            if !purchase.isPaid {
                Section {
                    Button("Adicionar Item") {
                        showingNewItemScreen = true
                    }
                }
            }
            
            ForEach($purchase.items.reversed()) { $item in // FIXME: order after deletion
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.product.name)
                            .bold()
                        
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
                        Text("\(item.quantity) × \(item.unitPrice, format: .currency(code: "BRL"))")
                            .font(.caption)
                        
                        Text(item.totalPrice, format: .currency(code: "BRL")) // TODO: locale
                            .bold()
                    }
                }
            }
            .onDelete { indexSet in
                deleteItem(from: purchase.items.reversed(), at: indexSet)
            }
        }
        .navigationTitle(Text(purchase.date, format: .dateTime.day().month().year()))
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: purchase.isPaid) // TODO: improve animation
        .toolbar {
//            ToolbarItem {
//                ShareLink(
//                    item: toString(purchase: purchase),
//                    preview: SharePreview(
//                        "Detalhes da venda"
//                        + (purchase.customer.map { " para \($0.name)" } ?? "")
//                        + " em \(purchase.date.formatted(date: .numeric, time: .omitted))"
//                    )
//                )
//            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    shareToWhatsApp(
                        content: toString(purchase: purchase),
                        to: purchase.customer?.phoneNumber
                    )
                } label: {
                    Image("WhatsApp_Digital_Glyph_Black")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
//                .labelStyle(.iconOnly)
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
                .contentMargins(.top, 10)
                .presentationDetents([.medium])
                .navigationTitle("Data da Compra")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Salvar") {
                            purchase.date = editPurchaseDate
                            showingEditDateScreen = false
                        } // TODO: extract?
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
    
    func deleteItem(from filteredItems: [Item], at indexSet: IndexSet) {
        for index in indexSet {
            let item = filteredItems[index]
            modelContext.delete(item)
        }
        
        try? modelContext.save()
    }
    
    func shareToWhatsApp(content: String, to phoneNumber: String?) {
        if let url = URL(string: "whatsapp://send?phone=\(phoneNumber ?? "")&text=\(content)") {
            UIApplication.shared.open(url)
        }
    }
    
    func toString(purchase: Purchase) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current

        var result = ""

//        result.append("```")

        result.append("*DATA: \(purchase.date.formatted(date: .numeric, time: .omitted))*\n\n")

        for item in purchase.items {
            let unit = formatter.string(from: item.unitPrice as NSDecimalNumber) ?? "\(item.unitPrice)"
            let total = formatter.string(from: item.totalPrice as NSDecimalNumber) ?? "\(item.totalPrice)"

            result.append("*\(item.product.name)* \(item.product.details)\n")
            result.append("\(unit) x \(item.quantity) = \(total)\n\n")
        }

        let totalFormatted = formatter.string(from: purchase.totalPrice as NSDecimalNumber) ?? "\(purchase.totalPrice)"
        result.append("*TOTAL = \(totalFormatted)*")

//        result.append("```")
        
        #if DEBUG
        print(result)
        #endif
        
        return result
    }
}

#Preview {
    let purchase = Purchase.sampleData.first!
    
    NavigationStack {
        PurchaseDetailView(purchase: purchase, path: .constant(NavigationPath()))
    }
}
