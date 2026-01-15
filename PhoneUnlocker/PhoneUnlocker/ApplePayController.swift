import Foundation
import PassKit

class ApplePayController: NSObject, ObservableObject, PKPaymentAuthorizationViewControllerDelegate {
    @Published var isProcessing = false
    
    private var paymentVC: PKPaymentAuthorizationViewController?
    private var continuation: CheckedContinuation<Void, Error>?
    
    override init() {
        super.init()
    }
    
    /// Initiates a zero-dollar transaction to trigger Face ID on iPhone
    func initiateZeroTransaction() async throws {
        guard PKPaymentAuthorizationViewController.canMakePayments() else {
            throw PaymentError.applePayNotAvailable
        }
        
        guard let paymentVC = createPaymentViewController() else {
            throw PaymentError.failedToCreateViewController
        }
        
        self.paymentVC = paymentVC
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            // Present the payment sheet
            if let keyWindow = NSApplication.shared.windows.first {
                if let rootViewController = keyWindow.rootViewController {
                    rootViewController.present(paymentVC, animated: true)
                }
            }
        }
    }
    
    private func createPaymentViewController() -> PKPaymentAuthorizationViewController? {
        // Create a zero-dollar payment request
        let paymentRequest = PKPaymentRequest()
        
        // Configure merchant information
        paymentRequest.merchantIdentifier = "merchant.com.phoneunlocker"
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex, .discover]
        paymentRequest.merchantCapabilities = .capability3DS
        
        // Create a zero-dollar transaction
        let summaryItem = PKPaymentSummaryItem(
            label: "iPhone Authentication",
            amount: NSDecimalNumber(value: 0.00)
        )
        
        paymentRequest.paymentSummaryItems = [summaryItem]
        
        // Request shipping contact for enhanced security
        paymentRequest.requiredShippingContactFields = []
        paymentRequest.requiredBillingContactFields = []
        
        // Create the authorization view controller
        return PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
    }
    
    // MARK: - PKPaymentAuthorizationViewControllerDelegate
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        // User completed Face ID authentication
        
        // Simulate processing the zero-dollar transaction
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(PKPaymentAuthorizationResult(status: .success, errors: []))
            
            // Notify the continuation that authentication was successful
            self.continuation?.resume()
            self.continuation = nil
            
            // Close the payment sheet
            controller.dismiss(animated: true)
        }
    }
    
    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didSelectPaymentMethod paymentMethod: PKPaymentMethod,
        handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void
    ) {
        completion(PKPaymentRequestPaymentMethodUpdate(paymentSummaryItems: []))
    }
}

enum PaymentError: LocalizedError {
    case applePayNotAvailable
    case failedToCreateViewController
    case transactionFailed
    
    var errorDescription: String? {
        switch self {
        case .applePayNotAvailable:
            return "Apple Pay is not available on this device"
        case .failedToCreateViewController:
            return "Failed to initialize payment sheet"
        case .transactionFailed:
            return "Transaction authentication failed"
        }
    }
}
