import SwiftUI

@main
struct YourProjectNameApp: App {
    @StateObject private var paymentViewModel = PaymentViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(paymentViewModel)
        }
    }
}
