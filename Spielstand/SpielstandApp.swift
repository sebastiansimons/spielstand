import SwiftUI

@main
struct SpielstandApp: App {
    var body: some Scene {
        WindowGroup {
            ScoreboardView()
                .onAppear {
                    // Keep the screen on during a game.
                    UIApplication.shared.isIdleTimerDisabled = true
                }
        }
    }
}
