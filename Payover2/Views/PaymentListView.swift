import SwiftUI

struct PaymentListView: View {
    @EnvironmentObject var viewModel: PaymentViewModel
    @State private var selectedPayment: Payment?
    @State private var isPresentingDetailView = false
    var paymentType: PaymentType?
    
    var body: some View {
        List {
            ForEach(filteredPayments) { payment in
                Button(action: {
                    selectedPayment = payment
                    isPresentingDetailView = true
                }) {
                    PaymentRowView(payment: payment)
                }
                .listRowBackground(Color.clear) // Make the row background clear
            }
            .onDelete(perform: deletePayment)
        }
        .listStyle(PlainListStyle()) // Use PlainListStyle for a cleaner look
        .background(Color.clear) // Set the background to clear
        .sheet(isPresented: $isPresentingDetailView, onDismiss: {
            selectedPayment = nil
        }) {
            if let selectedPayment = selectedPayment {
                PaymentDetailView(payment: selectedPayment)
                    .environmentObject(viewModel)
            }
        }
    }
    
    private var filteredPayments: [Payment] {
        if let paymentType = paymentType {
            return viewModel.payments.filter { $0.type == paymentType }
        } else {
            return viewModel.payments
        }
    }
    
    private func deletePayment(at offsets: IndexSet) {
        viewModel.deletePayment(at: offsets)
    }
}

struct PaymentListView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentListView(paymentType: .loan)
            .environmentObject(PaymentViewModel())
    }
}
