import Combine
import SwiftUI

class PaymentViewModel: ObservableObject {
    @Published var payments: [Payment] = []
    
    var totalPaymentAmount: Double {
        payments.reduce(0) { $0 + $1.monthlyPaymentAmount }
    }
    
    var totalMonthlyPaymentAmount: Double {
        payments.reduce(0) { $0 + $1.monthlyPaymentAmount }
    }
    
    init() {
        loadPayments()
    }
    
    func addPayment(_ payment: Payment) {
        payments.append(payment)
        savePayments()
    }
    
    func deletePayment(_ payment: Payment) {
        if let index = payments.firstIndex(where: { $0.id == payment.id }) {
            payments.remove(at: index)
            savePayments()
        }
    }
    
    func deletePayment(at offsets: IndexSet) {
        payments.remove(atOffsets: offsets)
        savePayments()
    }
    
    func updatePayment(_ payment: Payment) {
        if let index = payments.firstIndex(where: { $0.id == payment.id }) {
            payments[index] = payment
            savePayments()
        }
    }
    
    private func savePayments() {
        if let encoded = try? JSONEncoder().encode(payments) {
            UserDefaults.standard.set(encoded, forKey: "payments")
        }
    }
    
    private func loadPayments() {
        if let savedPayments = UserDefaults.standard.data(forKey: "payments"),
           let decodedPayments = try? JSONDecoder().decode([Payment].self, from: savedPayments) {
            self.payments = decodedPayments
        }
    }
}
