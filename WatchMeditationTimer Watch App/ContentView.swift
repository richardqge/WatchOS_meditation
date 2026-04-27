import SwiftUI
import Combine

struct ContentView: View {
    @State private var viewModel = MeditationTimerViewModel()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        if viewModel.hasStarted {
            timerView
        } else {
            setupView
        }
    }

    var setupView: some View {
        SetupView(
            durations: viewModel.durations,
            selectedMinutes: viewModel.selectedMinutes,
            onSelectMinutes: viewModel.selectMinutes,
            onStart: viewModel.startTimer
        )
    }

    var timerView: some View {
        TimerView(
            breathPhase: viewModel.breathPhase,
            secondsRemaining: viewModel.secondsRemaining,
            isRunning: viewModel.isRunning,
            onPauseResume: viewModel.pauseResumeTimer,
            onReset: viewModel.resetTimer
        )
        .onReceive(timer) { _ in
            viewModel.tick()
        }
    }
}

#Preview {
    ContentView()
}
