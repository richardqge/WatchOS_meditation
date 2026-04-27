//
//  SetupView.swift
//  WatchMeditationTimer
//
//  Created by Richard Ge on 4/26/26.
//

import SwiftUI

struct SetupView: View {
    let durations: [Int]
    let selectedMinutes: Int
    let onSelectMinutes: (Int) -> Void
    let onStart: () -> Void

    var body: some View {
        VStack {
            Text("Minutes")

            HStack {
                ForEach(durations, id: \.self) { minutes in
                    Button("\(minutes)") {
                        onSelectMinutes(minutes)
                    }
                }
            }

            Text("Selected: \(selectedMinutes)")

            Button("Start") {
                onStart()
            }
        }
    }
}
