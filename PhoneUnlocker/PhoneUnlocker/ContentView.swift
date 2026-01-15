import SwiftUI
import PassKit

struct ContentView: View {
    @EnvironmentObject var paymentController: ApplePayController
    @EnvironmentObject var screensaverManager: ScreensaverManager
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Phone Unlock")
                .font(.headline)
            
            Text("Unlock your Mac screensaver using Face ID on your iPhone")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Divider()
            
            // Status Section
            VStack(alignment: .leading, spacing: 8) {
                Label("Screensaver Status", systemImage: "eye")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                HStack {
                    Circle()
                        .fill(screensaverManager.isActive ? Color.red : Color.green)
                        .frame(width: 12, height: 12)
                    
                    Text(screensaverManager.isActive ? "Active" : "Inactive")
                        .font(.caption)
                }
                .padding(8)
                .background(Color(.controlBackgroundColor))
                .cornerRadius(6)
            }
            
            // Main Action Button
            if PKPaymentAuthorizationViewController.canMakePayments() {
                Button(action: initiatePhoneAuth) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        HStack {
                            Image(systemName: "iphone")
                            Text("Verify with iPhone")
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .controlSize(.large)
                .disabled(isLoading || !screensaverManager.isActive)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title3)
                        .foregroundColor(.orange)
                    
                    Text("Apple Pay Not Available")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text("Configure Apple Pay in System Preferences > Wallet & Apple Pay")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.controlBackgroundColor))
                .cornerRadius(6)
            }
            
            // Error Message
            if let error = errorMessage {
                Label(error, systemImage: "exclamationmark.circle")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(6)
            }
            
            // Success Message
            if showSuccess {
                Label("Mac unlocked successfully!", systemImage: "checkmark.circle")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(6)
            }
            
            Divider()
            
            // Settings
            VStack(alignment: .leading, spacing: 8) {
                Button(action: openSystemPreferences) {
                    Label("Security & Privacy Settings", systemImage: "gear")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: openAbout) {
                    Label("About PhoneUnlocker", systemImage: "info.circle")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .frame(width: 300)
    }
    
    private func initiatePhoneAuth() {
        isLoading = true
        errorMessage = nil
        showSuccess = false
        
        Task {
            do {
                try await paymentController.initiateZeroTransaction()
                
                // If payment succeeds, unlock the screensaver
                try await screensaverManager.unlockScreensaver()
                
                showSuccess = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showSuccess = false
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    private func openSystemPreferences() {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security")!)
    }
    
    private func openAbout() {
        if let url = URL(string: "https://github.com/maksimvialykh/macOS-phone-unlock") {
            NSWorkspace.shared.open(url)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ApplePayController())
        .environmentObject(ScreensaverManager())
}
