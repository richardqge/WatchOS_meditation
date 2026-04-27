import SwiftUI
import Combine
import WatchKit

struct ContentView: View {
    @State private var selectedMinutes = 5
    @State private var secondsRemaining = 5 * 60
    @State private var isRunning = false

    let durations = [1, 3, 5, 10]
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Minutes")

            HStack {
                ForEach(durations, id: \.self) { minutes in
                    Button("\(minutes)") {
                        selectedMinutes = minutes
                        secondsRemaining = minutes * 60
                    }
                    .disabled(isRunning)
                }
            }

            Text(formatTime(secondsRemaining))
                .font(.title)

            Button(isRunning ? "Pause" : "Start") {
                isRunning.toggle()
                WKInterfaceDevice.current().play(.click)
            }

            Button("Reset") {
                resetTimer()
                WKInterfaceDevice.current().play(.click)
            }
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }

            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                isRunning = false
                WKInterfaceDevice.current().play(.success)
            }
        }
    }

    func resetTimer() {
        secondsRemaining = selectedMinutes * 60
        isRunning = false
    }

    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
