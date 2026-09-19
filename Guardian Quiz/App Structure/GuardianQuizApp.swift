//
//  GuardianQuizApp.swift
//  Guardian Quiz
//
//  Created by Simon Whitaker on 28/01/2023.
//

import SwiftUI

@main
struct GuardianQuizApp: App {
    @StateObject private var sharedState: SharedState = SharedState()

    var body: some Scene {
        WindowGroup {
            QuizmasterView()
                .environmentObject(sharedState)
                .sceneAccessory {
                    ExternalNonInteractiveAccessory {
                        PlayerView()
                            .environmentObject(sharedState)
                            .onAppear { sharedState.isSecondScreenVisible = true }
                            .onDisappear { sharedState.isSecondScreenVisible = false }
                    }
                }
        }
    }
}
