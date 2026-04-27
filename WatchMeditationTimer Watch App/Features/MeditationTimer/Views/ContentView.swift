import SwiftUI
import Combine


struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase

    
    let viewModel: MeditationTimerViewModel
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        mainContent
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase != .active {
                    viewModel.pauseForAppLifecycle()
                }
            }
    }
    
    @ViewBuilder
    var mainContent: some View {
        if viewModel.hasStarted{
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
            onStart: viewModel.startTimer,
            recommendedMinutes: viewModel.recommendedMinutes,
            isLoadingRecommendation: viewModel.isLoadingRecommendation,
            onLoadRecommendation: {
                Task {
                    await viewModel.loadRecommendation()
                }
            }
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
    ContentView(viewModel: MeditationTimerViewModel(haptics: SilentHaptics()))
}
