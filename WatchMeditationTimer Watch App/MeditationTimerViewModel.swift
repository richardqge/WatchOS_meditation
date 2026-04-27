//
//  MeditationTimerViewModel.swift
//  WatchMeditationTimer
//
//  Created by Richard Ge on 4/26/26.
//

import Observation

struct BreathingStep {
    let phase: BreathPhase
    let duration: Int
}

@Observable
class MeditationTimerViewModel {
    private let haptics: HapticsProviding
    

    
    private(set) var selectedMinutes = 5
    private(set) var secondsRemaining = 5 * 60
    private(set) var elapsedSeconds = 0
    private(set) var isRunning = false
    private(set) var hasStarted = false
    private(set) var breathPhase: BreathPhase = .ready

    let durations = [1, 3, 5, 10]
    
    // cycle as data
    private let breathingPattern: [BreathingStep] = [
        BreathingStep(phase: .inhale, duration: 4),
        BreathingStep(phase: .hold, duration: 3),
        BreathingStep(phase: .exhale, duration: 5)
    ]
    
    // cycle length
    private var breathingCycleLength: Int {
        breathingPattern.reduce(0) {total, step in
            total + step.duration
        }
    }
    

    init(haptics: HapticsProviding = Haptics()) {
        self.haptics = haptics
    }

    func startTimer() {
        secondsRemaining = selectedMinutes * 60
        elapsedSeconds = 0
        isRunning = true
        hasStarted = true
        breathPhase = .inhale
        haptics.start()
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
        haptics.click()
    }

    func selectMinutes(_ minutes: Int) {
        guard durations.contains(minutes) else { return }
        
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
            haptics.success()
        }
    }

    private func updateBreathPhase() {
        let cycleSecond = elapsedSeconds % breathingCycleLength
        var elapsedInCycle = 0

        for step in breathingPattern {
            elapsedInCycle += step.duration

            if cycleSecond < elapsedInCycle {
                breathPhase = step.phase
                return
            }
        }
    }
}
