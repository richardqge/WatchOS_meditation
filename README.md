# WatchMeditationTimer

Learning watchOS.

## Architecture

```text
WatchMeditationTimer Watch App/
├── App/
│   └── WatchMeditationTimerApp.swift
├── Features/
│   └── MeditationTimer/
│       ├── Models/
│       │   ├── BreathPhase.swift
│       │   └── BreathingStep.swift
│       ├── ViewModels/
│       │   └── MeditationTimerViewModel.swift
│       └── Views/
│           ├── ContentView.swift
│           ├── SetupView.swift
│           └── TimerView.swift
└── Services/
    ├── DurationStore.swift
    └── Haptics.swift
```

- `ContentView` wires the timer feature together.
- `SetupView` shows duration selection and recommendation UI.
- `TimerView` shows the active meditation timer.
- `MeditationTimerViewModel` owns timer state and app logic.
- `Services` contains external dependencies like persistence and haptics.
