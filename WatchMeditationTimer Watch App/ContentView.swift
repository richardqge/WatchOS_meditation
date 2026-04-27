import SwiftUI
import Combine

struct ContentView: View {
    @State private var secondsRemaining = 5*60
    @State private var isRunning = false
    
    // create a timer that ticks every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            Text(formatTime(secondsRemaining))
                .font(.title)
            
            Button(isRunning ? "Pause": "Start"){
                isRunning.toggle()
            }
            
            Button("Reset"){
                secondsRemaining = 5*60
                isRunning = false
            }
        }
        .onReceive(timer){ _ in // this runs every second
            guard isRunning else {return}
            
            if secondsRemaining > 0{
                secondsRemaining -= 1
            } else {
                isRunning = false
            }
        }
        
    }
    
    func formatTime(_ seconds: Int) -> String{
        let minutes = seconds / 60
        let seconds = seconds % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
