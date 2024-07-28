import SwiftUI

struct PaymentDetailView: View {
    @EnvironmentObject var viewModel: PaymentViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    @State private var editedPayment: Payment
    var payment: Payment

    init(payment: Payment) {
        _editedPayment = State(initialValue: payment)
        self.payment = payment
    }

    var body: some View {
        VStack {
            Text(payment.name)
                .font(.largeTitle)
                .padding()
            
            Text("Payment Details")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 10) {
                if isEditing {
                    HStack {
                        Text("Payment Name:")
                        Spacer()
                        TextField("", text: $editedPayment.name)
                            .multilineTextAlignment(.trailing)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.clear, lineWidth: 0)
                            )
                    }
                    HStack {
                        Text("Payment Day:")
                        Spacer()
                        TextField("", value: $editedPayment.day, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.clear, lineWidth: 0)
                            )
                    }
                    HStack {
                        Text("Monthly Payment Amount:")
                        Spacer()
                        TextField("", value: $editedPayment.monthlyPaymentAmount, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.clear, lineWidth: 0)
                            )
                    }
                    if payment.type == .loan || payment.type == .creditCard {
                        HStack {
                            Text("Paid Installment Count:")
                            Spacer()
                            TextField("", value: $editedPayment.paidInstallments, formatter: NumberFormatter())
                                .multilineTextAlignment(.trailing)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.clear, lineWidth: 0)
                                )
                        }
                        HStack {
                            Text("Total Installments:")
                            Spacer()
                            TextField("", value: $editedPayment.totalInstallments, formatter: NumberFormatter())
                                .multilineTextAlignment(.trailing)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.clear, lineWidth: 0)
                                )
                        }
                    }
                } else {
                    HStack {
                        Text("Payment Day:")
                        Spacer()
                        Text("\(formattedDay(editedPayment.day))")
                    }
                    Divider()
                    HStack {
                        Text("Monthly Payment Amount:")
                        Spacer()
                        Text("\(editedPayment.monthlyPaymentAmount, specifier: "%.2f") ₺")
                    }
                    if payment.type == .loan || payment.type == .creditCard {
                        Divider()
                        HStack {
                            Text("Paid Installment Count:")
                            Spacer()
                            Text("\(editedPayment.paidInstallments ?? 0)")
                        }
                        Divider()
                        HStack {
                            Text("Total Installments:")
                            Spacer()
                            Text("\(editedPayment.totalInstallments ?? 0)")
                        }
                        Divider()
                        HStack {
                            Text("Total Debt:")
                            Spacer()
                            Text("\(editedPayment.totalDebt, specifier: "%.2f") ₺")
                                .bold()
                        }
                        Divider()
                        HStack {
                            Text("Remaining Debt:")
                            Spacer()
                            Text("\(remainingDebt, specifier: "%.2f") ₺")
                                .bold()
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()

            HStack {
                Button(action: {
                    isEditing.toggle()
                    if !isEditing {
                        viewModel.updatePayment(editedPayment)
                    }
                }) {
                    Text(isEditing ? "Save" : "Edit")
                        .foregroundColor(.white)
                        .padding()
                        .background(isEditing ? Color.green : Color.blue)
                        .cornerRadius(8)
                }

                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Delete Payment"),
                        message: Text("Are you sure you want to delete this payment?"),
                        primaryButton: .destructive(Text("Delete")) {
                            viewModel.deletePayment(payment)
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
        }
        .padding()
    }

    private var remainingDebt: Double {
        let totalInstallments = editedPayment.totalInstallments ?? 0
        let paidInstallments = editedPayment.paidInstallments ?? 0
        let remainingInstallments = totalInstallments - paidInstallments
        return editedPayment.monthlyPaymentAmount * Double(remainingInstallments)
    }

    private func formattedDay(_ day: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: day)) ?? "\(day)"
    }
}

struct PaymentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailView(payment: Payment(name: "Example Payment", day: 15, type: .loan, monthlyPaymentAmount: 200.0, paidInstallments: 2, totalInstallments: 10))
            .environmentObject(PaymentViewModel())
    }
}
