//
//  MeditationTimerViewModel.swift
//  WatchMeditationTimer
//
//  Created by Richard Ge on 4/26/26.
//

import Observation
import Foundation

@MainActor
@Observable
class MeditationTimerViewModel {
    
    // inject for testing
    private let durationStore: DurationStoring
    
    private let selectedMinutesKey = "selectedMinutes"
    private let haptics: HapticsProviding
    
    init() {
        self.haptics = Haptics()
        self.durationStore = DurationStore()
        loadSavedDuration()

    }

    init(
        haptics: HapticsProviding,
        durationStore: DurationStoring = EmptyDurationStore()
    ) {
        self.haptics = haptics
        self.durationStore = durationStore
        loadSavedDuration()
    }
    
    
    private(set) var selectedMinutes = 5
    private(set) var secondsRemaining = 5 * 60
    private(set) var elapsedSeconds = 0
    private(set) var isRunning = false
    private(set) var hasStarted = false
    private(set) var breathPhase: BreathPhase = .ready
    
    // async
    private(set) var recommendedMinutes: Int?
    private(set) var isLoadingRecommendation = false

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
        durationStore.saveSelectedMinutes(minutes)

    }

    func tick() {
        guard isRunning else { return }

        guard secondsRemaining > 0 else {
            isRunning = false
            breathPhase = .done
            haptics.success()
            return
        }

        secondsRemaining -= 1
        elapsedSeconds += 1

        if secondsRemaining == 0 {
            isRunning = false
            breathPhase = .done
            haptics.success()
        } else {
            updateBreathPhase()
        }
    }
    
    func loadRecommendation() async{
        isLoadingRecommendation = true
        
        try? await Task.sleep(for: .seconds(1))
        
        recommendedMinutes = 3
        isLoadingRecommendation = false
    }
    
    func pauseForAppLifecycle() {
        guard isRunning else { return }

        isRunning = false
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
    
    private func loadSavedDuration() {
        guard let savedMinutes = durationStore.loadSelectedMinutes(),
              durations.contains(savedMinutes)
        else {
            return
        }

        selectedMinutes = savedMinutes
        secondsRemaining = savedMinutes * 60
    }

}
