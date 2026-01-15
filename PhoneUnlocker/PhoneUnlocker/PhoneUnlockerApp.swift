import SwiftUI
import PassKit

@main
struct PhoneUnlockerApp: App {
    @StateObject private var paymentController = ApplePayController()
    @StateObject private var screensaverManager = ScreensaverManager()
    
    var body: some Scene {
        MenuBarExtra("PhoneUnlocker", systemImage: "iphone.badge.checkmark") {
            ContentView()
                .environmentObject(paymentController)
                .environmentObject(screensaverManager)
        }
    }
}
