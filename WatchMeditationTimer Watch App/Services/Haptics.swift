//
//  Haptics.swift
//  WatchMeditationTimer
//
//  Created by Richard Ge on 4/26/26.
//

import WatchKit

@MainActor
protocol HapticsProviding {
    func start()
    func click()
    func success()
}

struct Haptics: HapticsProviding {
    nonisolated init() {}

    func start() {
        WKInterfaceDevice.current().play(.start)
    }

    func click() {
        WKInterfaceDevice.current().play(.click)
    }

    func success() {
        WKInterfaceDevice.current().play(.success)
    }
}

struct SilentHaptics: HapticsProviding {
    func start() {}
    func click() {}
    func success() {}
}

