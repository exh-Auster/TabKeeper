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
    var body: some View {
        TabView {
            Tab("Clientes", systemImage: "person.3.fill") {
//                person.crop.rectangle.stack.fill; person.text.rectangle.fill
                CustomerListView()
            }
            
            Tab("Em Aberto", systemImage: "creditcard.trianglebadge.exclamationmark.fill") {
//                creditcard.trianglebadge.exclamationmark.fill; clock.arrow.circlepath; calendar.badge.exclamationmark
                Text("Placeholder")
            }
            .disabled(true)
            
            Tab("Produtos", systemImage: "shippingbox.fill") {
                Text("Placeholder")
            }
            .disabled(true)
            
            Tab("Estatísticas", systemImage: "chart.bar.fill") {
                Text("Placeholder")
            }
            .disabled(true)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.shared.modelContainer)
}
