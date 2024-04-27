//  ExpenseTrackingAppApp.swift
//  ExpenseTrackingApp
//  Created by Yash Sawant on 4/3/24.
import SwiftUI

@main
struct ExpenseTrackingAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ActivityViewModel(context: persistenceController.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

