import SwiftUI

struct AddPaymentView: View {
    @EnvironmentObject var viewModel: PaymentViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedPaymentType: PaymentType = .loan
    @State private var paymentName: String = ""
    @State private var paymentDay: Int = 1
    @State private var paymentCount: Int?
    @State private var paidInstallmentCount: Int?
    @State private var paymentAmount: Double?
    
    var body: some View {
        VStack {
            Text("Add New Regular Payment")
                .font(.headline)
                .padding()
            
            // Dropdown menu for Payment Type
            Menu {
                Picker(selection: $selectedPaymentType, label: Text("")) {
                    Text("Loan").tag(PaymentType.loan)
                    Text("Credit Card").tag(PaymentType.creditCard)
                    Text("Subscription").tag(PaymentType.subscription)
                    Text("Other").tag(PaymentType.other)
                }
            } label: {
                HStack {
                    Text(selectedPaymentType.rawValue)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Payment Name:")
                    Spacer()
                    TextField("...", text: $paymentName)
                        .multilineTextAlignment(.trailing)
                }
                Divider()
                HStack {
                    Text("Payment Day:")
                    Spacer()
                    Picker("...", selection: $paymentDay) {
                        ForEach(1...31, id: \.self) {
                            Text("\($0)").tag($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                Divider()
                
                if selectedPaymentType == .loan || selectedPaymentType == .creditCard || selectedPaymentType == .other {
                    HStack {
                        Text("Payment Count:")
                        Spacer()
                        TextField("...", value: $paymentCount, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    Divider()
                }

                if selectedPaymentType == .loan || selectedPaymentType == .creditCard {
                    HStack {
                        Text("Paid Installment Count:")
                        Spacer()
                        TextField("...", value: $paidInstallmentCount, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    Divider()
                }

                HStack {
                    Text("Monthly Payment Amount:")
                    Spacer()
                    TextField("...", value: $paymentAmount, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()

            Button(action: addPayment) {
                Text("Add Payment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .padding()
    }
    
    private func addPayment() {
        let newPayment = Payment(
            name: paymentName,
            day: paymentDay,
            type: selectedPaymentType,
            monthlyPaymentAmount: paymentAmount ?? 0.0,
            paidInstallments: selectedPaymentType == .loan || selectedPaymentType == .creditCard ? paidInstallmentCount : nil,
            totalInstallments: selectedPaymentType == .loan || selectedPaymentType == .creditCard || selectedPaymentType == .other ? paymentCount : nil,
            isEndless: selectedPaymentType == .subscription
        )
        
        viewModel.addPayment(newPayment)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaymentView()
            .environmentObject(PaymentViewModel())
    }
}
