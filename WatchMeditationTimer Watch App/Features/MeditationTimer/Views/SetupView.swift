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
    
    //async
    let recommendedMinutes: Int?
    let isLoadingRecommendation: Bool
    let onLoadRecommendation: () -> Void
    
    private var selectedDurationIndex: Binding<Double> {
        Binding(
            get: {
                guard let index = durations.firstIndex(of: selectedMinutes) else {
                    return 0
                }

                return Double(index)
            },
            set: { newValue in
                guard !durations.isEmpty else { return }

                let index = Int(newValue.rounded())
                let clampedIndex = min(max(index, 0), durations.count - 1)
                let minutes = durations[clampedIndex]

                onSelectMinutes(minutes)
            }
        )
    }

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
            
            if isLoadingRecommendation {
                Text("Loading...")
            } else if let recommendedMinutes {
                Button("Use \(recommendedMinutes) min") {
                    onSelectMinutes(recommendedMinutes)
                }
            } else {
                Button("Recommend") {
                    onLoadRecommendation()
                }
            }

            Button("Start") {
                onStart()
            }
        }
        .focusable(true)
        .digitalCrownRotation(
            selectedDurationIndex,
            from: 0,
            through: Double(durations.count - 1),
            by: 1,
            sensitivity: .medium,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
    }

}

#Preview {
    SetupView(
        durations: [1, 3, 5, 10],
        selectedMinutes: 5,
        onSelectMinutes: { _ in },
        onStart: {},
        recommendedMinutes: nil,
        isLoadingRecommendation: false,
        onLoadRecommendation: {}
    )
}
