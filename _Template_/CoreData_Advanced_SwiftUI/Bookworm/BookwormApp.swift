//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Cyrus on 10/6/2022.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject private var dataController = DataController() // This is where the Core Data container is
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext) // Share the context container bewteen different views through environment()
        }
    }
}
