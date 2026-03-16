//
//  PurchaseRowView.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 07/05/25.
//

import SwiftUI

struct PurchaseRowView: View {
    let purchase: Purchase
    
    @State var showCustomerName = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if showCustomerName {
                    Text(purchase.customer?.name ?? "")
                        .bold()
                }
                
                Text(purchase.date.formatted(date: .numeric, time: .omitted))
                    .bold()
                
                Text(purchase.totalPrice, format: .currency(code: "BRL")) // TODO: locale
            }
            
            Spacer()
            
            Image(systemName: purchase.isPaid ? "checkmark.circle.fill" : "x.circle")
                .foregroundStyle(purchase.isPaid ? .green : .red) // TODO: time since purchase?
        }
    }
}

#Preview("No customer name") {
    let purchase = PreviewSampleData.shared.paidPurchase
    
    PurchaseRowView(purchase: purchase)
}

#Preview("With customer name") {
    let purchase = PreviewSampleData.shared.paidPurchase
    
    PurchaseRowView(purchase: purchase, showCustomerName: true)
}

#Preview("In List, no customer name") {
    let unpaidPurchase = PreviewSampleData.shared.unpaidPurchase
    let paidPurchase = PreviewSampleData.shared.paidPurchase
    
    List {
        PurchaseRowView(purchase: unpaidPurchase)
        PurchaseRowView(purchase: paidPurchase)
    }
}

#Preview("In List, with customer name") {
    let unpaidPurchase = PreviewSampleData.shared.unpaidPurchase
    let paidPurchase = PreviewSampleData.shared.paidPurchase
    
    List {
        PurchaseRowView(purchase: unpaidPurchase, showCustomerName: true)
        PurchaseRowView(purchase: paidPurchase, showCustomerName: true)
    }
}
