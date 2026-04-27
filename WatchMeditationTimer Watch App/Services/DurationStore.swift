//
//  DurationStore.swift
//  WatchMeditationTimer
//
//  Created by Richard Ge on 4/26/26.
//

import Foundation

// test/preview store
struct EmptyDurationStore: DurationStoring {
    func loadSelectedMinutes() -> Int? {
        nil
    }

    func saveSelectedMinutes(_ minutes: Int) {}
}

protocol DurationStoring {
    func loadSelectedMinutes() -> Int?
    func saveSelectedMinutes(_ minutes: Int)
}

struct DurationStore: DurationStoring {
    private let selectedMinutesKey = "selectedMinutes"

    func loadSelectedMinutes() -> Int? {
        let value = UserDefaults.standard.integer(forKey: selectedMinutesKey)

        if value == 0 {
            return nil
        }

        return value
    }

    func saveSelectedMinutes(_ minutes: Int) {
        UserDefaults.standard.set(minutes, forKey: selectedMinutesKey)
    }
}

final class InMemoryDurationStore: DurationStoring {
    private var selectedMinutes: Int?

    init(selectedMinutes: Int? = nil) {
        self.selectedMinutes = selectedMinutes
    }

    func loadSelectedMinutes() -> Int? {
        selectedMinutes
    }

    func saveSelectedMinutes(_ minutes: Int) {
        selectedMinutes = minutes
    }
}

