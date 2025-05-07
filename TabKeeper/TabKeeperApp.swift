//
//  TabKeeperApp.swift
//  TabKeeper
//
//  Created by Felipe Ribeiro on 27/04/25.
//

import SwiftData
import SwiftUI

@main
struct TabKeeperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if(DEBUG)
        .modelContainer(PreviewSampleData.container)
        #else
        .modelContainer(for: [Customer.self, Purchase.self, Item.self, Product.self])
        #endif
    }
}
