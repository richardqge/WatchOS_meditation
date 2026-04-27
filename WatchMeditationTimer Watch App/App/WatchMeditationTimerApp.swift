//
//  WatchMeditationTimerApp.swift
//  WatchMeditationTimer Watch App
//
//  Created by Richard Ge on 4/26/26.
//

import SwiftUI

@main
struct WatchMeditationTimerApp: App {
    @State private var viewModel = MeditationTimerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
