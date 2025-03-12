//
//  ArtiaApp.swift
//  Artia
//
//  Created by Vick on 3/11/25.
//

import SwiftUI

@main
struct ArtiaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(MissionStore())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
