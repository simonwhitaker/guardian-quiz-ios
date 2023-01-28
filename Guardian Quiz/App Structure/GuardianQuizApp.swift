//
//  GuardianQuizApp.swift
//  Guardian Quiz
//
//  Created by Simon Whitaker on 28/01/2023.
//

import SwiftUI
import Combine

@main
struct GuardianQuizApp: App {
    @StateObject private var sharedState: SharedState = SharedState()
    @State var additionalWindows: [UIWindow] = []

    private var screenDidConnectPublisher: AnyPublisher<UIScreen, Never> {
        NotificationCenter.default
            .publisher(for: UIScreen.didConnectNotification)
            .compactMap { $0.object as? UIScreen }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private var screenDidDisconnectPublisher: AnyPublisher<UIScreen, Never> {
        NotificationCenter.default
            .publisher(for: UIScreen.didDisconnectNotification)
            .compactMap { $0.object as? UIScreen }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    var body: some Scene {
        WindowGroup {
            QuizmasterView()
                .environmentObject(sharedState)
                .onReceive(
                    screenDidConnectPublisher,
                    perform: screenDidConnect
                )
                .onReceive(
                    screenDidDisconnectPublisher,
                    perform: screenDidDisconnect
                )
        }
    }

    private func screenDidConnect(_ screen: UIScreen) {
        let window = UIWindow(frame: screen.bounds)

        window.windowScene = UIApplication.shared.connectedScenes
            .first { ($0 as? UIWindowScene)?.screen == screen }
        as? UIWindowScene

        let view = PlayerView()
            .environmentObject(sharedState)
        let controller = UIHostingController(rootView: view)
        window.rootViewController = controller
        window.isHidden = false
        additionalWindows.append(window)

        sharedState.isSecondScreenVisible = true
    }

    private func screenDidDisconnect(_ screen: UIScreen) {
        additionalWindows.removeAll { $0.screen == screen }
        sharedState.isSecondScreenVisible = false
    }
}
