//
//  ToDoApp.swift
//  ToDo
//
//  Created by 이예민 on 2023/01/29.
//

import SwiftUI

@main
struct ToDoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
