//
//  MeditationTimerViewModel.swift
//  WatchMeditationTimer
//
//  Created by Richard Ge on 4/26/26.
//

import Observation
import WatchKit

@Observable
class MeditationTimerViewModel {
    var selectedMinutes = 5
    var secondsRemaining = 5 * 60
    var elapsedSeconds = 0
    var isRunning = false
    var hasStarted = false
    var breathPhase: BreathPhase = .ready

    let durations = [1, 3, 5, 10]

    func startTimer() {
        secondsRemaining = selectedMinutes * 60
        elapsedSeconds = 0
        isRunning = true
        hasStarted = true
        breathPhase = .inhale
        WKInterfaceDevice.current().play(.start)
    }

    func resetTimer() {
        secondsRemaining = selectedMinutes * 60
        elapsedSeconds = 0
        isRunning = false
        hasStarted = false
        breathPhase = .ready
    }

    func pauseResumeTimer() {
        isRunning.toggle()
        WKInterfaceDevice.current().play(.click)
    }

    func selectMinutes(_ minutes: Int) {
        selectedMinutes = minutes
        secondsRemaining = minutes * 60
    }

    func tick() {
        guard isRunning else { return }

        if secondsRemaining > 0 {
            secondsRemaining -= 1
            elapsedSeconds += 1
            updateBreathPhase()
        } else {
            isRunning = false
            breathPhase = .done
            WKInterfaceDevice.current().play(.success)
        }
    }

    private func updateBreathPhase() {
        let cycleSecond = elapsedSeconds % 12

        if cycleSecond < 4 {
            breathPhase = .inhale
        } else if cycleSecond < 7 {
            breathPhase = .hold
        } else {
            breathPhase = .exhale
        }
    }
}
