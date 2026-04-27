//
//  BreathPhase.swift
//  WatchMeditationTimer
//
//  Created by Richard Ge on 4/26/26.
//

import SwiftUI

enum BreathPhase {
    case ready
    case inhale
    case hold
    case exhale
    case done

    var text: String {
        switch self {
        case .ready:
            return "Ready"
        case .inhale:
            return "Inhale"
        case .hold:
            return "Hold"
        case .exhale:
            return "Exhale"
        case .done:
            return "Done"
        }
    }

    var circleSize: CGFloat {
        switch self {
        case .inhale, .hold:
            return 110
        default:
            return 60
        }
    }
}
