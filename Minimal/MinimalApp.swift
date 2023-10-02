//
//  MinimalApp.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 2.10.23.
//

import SwiftUI

@main
struct MinimalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
