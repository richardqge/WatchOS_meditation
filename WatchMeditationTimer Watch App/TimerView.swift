//
//  TimerView.swift
//  WatchMeditationTimer
//
//  Created by Richard Ge on 4/26/26.
//

import SwiftUI

struct TimerView: View {
    let breathPhase: BreathPhase
    let secondsRemaining: Int
    let isRunning: Bool
    let onPauseResume: () -> Void
    let onReset: () -> Void

    var body: some View {
        VStack {
            Circle()
                .frame(
                    width: breathPhase.circleSize,
                    height: breathPhase.circleSize
                )
                .animation(.easeInOut(duration: 1), value: breathPhase.circleSize)

            Text(breathPhase.text)

            Text(formatTime(secondsRemaining))
                .font(.title)

            Button(isRunning ? "Pause" : "Resume") {
                onPauseResume()
            }

            Button("Reset") {
                onReset()
            }
        }
    }

    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }
}
