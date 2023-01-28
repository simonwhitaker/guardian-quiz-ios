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

    private var sceneWillConnectPublisher: AnyPublisher<UIWindowScene, Never> {
        NotificationCenter.default
            .publisher(for: UIScene.willConnectNotification)
            .compactMap { $0.object as? UIWindowScene }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private var sceneDidDisconnectPublisher: AnyPublisher<UIWindowScene, Never> {
        NotificationCenter.default
            .publisher(for: UIScene.didDisconnectNotification)
            .compactMap { $0.object as? UIWindowScene }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    var body: some Scene {
        WindowGroup {
            QuizmasterView()
                .environmentObject(sharedState)
                .onReceive(
                    sceneWillConnectPublisher,
                    perform: sceneWillConnect
                )
                .onReceive(
                    sceneDidDisconnectPublisher,
                    perform: sceneDidDisconnect
                )
        }
    }

    private func sceneWillConnect(_ scene: UIWindowScene) {
        let window = UIWindow(frame: scene.screen.bounds)

        window.windowScene = scene

        let view = PlayerView()
            .environmentObject(sharedState)
        let controller = UIHostingController(rootView: view)
        window.rootViewController = controller
        window.isHidden = false
        additionalWindows.append(window)

        sharedState.isSecondScreenVisible = true
    }

    private func sceneDidDisconnect(_ scene: UIWindowScene) {
        additionalWindows.removeAll { $0.screen == scene.screen }
        sharedState.isSecondScreenVisible = false
    }
}
