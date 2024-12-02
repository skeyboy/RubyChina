//
//  RubyChinaApp.swift
//  RubyChina
//
//  Created by lee on 2024/11/28.
//

import SwiftUI
import SwiftData
import MarkdownUI

@main
struct RubyChinaApp: App {
    @StateObject var pathManager: PathManager = .manager
    @State private var color: ColorScheme = .light
    @Environment(\.colorScheme) var colorScheme
    init(){
        pathManager.color = colorScheme == .dark ? .dark : .light
    }
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .preferredColorScheme(pathManager.color)
        }
        .environmentObject(pathManager)
        .modelContainer(sharedModelContainer)
    }
}
