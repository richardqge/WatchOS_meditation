//
//  WatchMeditationTimerTests.swift
//  WatchMeditationTimerTests
//
//  Created by Richard Ge on 4/26/26.
//

import Testing
@testable import WatchMeditationTimer_Watch_App

@MainActor
struct WatchMeditationTimerTests {

    @Test func startTimerBeginSession(){
        let viewModel = MeditationTimerViewModel(haptics: SilentHaptics())
        
        viewModel.startTimer()
        
        #expect(viewModel.hasStarted == true)
        #expect(viewModel.isRunning == true)
        #expect(viewModel.secondsRemaining == 5*60)
        #expect(viewModel.breathPhase == .inhale)
    }
    
    @Test func tickDecreasesRemainingTime(){
        let viewModel = MeditationTimerViewModel(haptics: SilentHaptics())
        
        viewModel.startTimer()
        viewModel.tick()
        
        #expect(viewModel.secondsRemaining == 299)
        #expect(viewModel.elapsedSeconds == 1)
        #expect(viewModel.breathPhase == .inhale)
    }
    
    @Test func tickDoesNothingWhenPaused() {
        let viewModel = MeditationTimerViewModel(haptics: SilentHaptics())

        viewModel.startTimer()
        viewModel.pauseResumeTimer()
        viewModel.tick()

        #expect(viewModel.secondsRemaining == 300)
        #expect(viewModel.elapsedSeconds == 0)
        #expect(viewModel.isRunning == false)
    }
    
    @Test func selectMinutesUpdatesDuration() {
        let viewModel = MeditationTimerViewModel(haptics: SilentHaptics())

        viewModel.selectMinutes(3)

        #expect(viewModel.selectedMinutes == 3)
        #expect(viewModel.secondsRemaining == 180)
    }
    
    @Test func selectMinutesIgnoresInvalidDuration() {
        let viewModel = MeditationTimerViewModel(haptics: SilentHaptics())

        viewModel.selectMinutes(999)

        #expect(viewModel.selectedMinutes == 5)
        #expect(viewModel.secondsRemaining == 300)
    }


}
