//
//  EnhancedTodoListApp.swift
//  EnhancedTodoList
//
//  Created by Sophie Haber on 21.11.24.
//

import SwiftData
import SwiftUI

@main
struct EnhancedTodoListApp: App {
    var body: some Scene {
        WindowGroup {
            LandingView()
        }
        .modelContainer(for: TodoItem.self)
    }
}
