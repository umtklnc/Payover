import SwiftUI

struct PaymentRowView: View {
    var payment: Payment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(payment.name)
                    .font(.headline)
                
                Text("\(payment.day)th day of the month")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("\(payment.monthlyPaymentAmount, specifier: "%.2f") ₺")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            if payment.isEndless {
                Text("∞")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else if let totalInstallments = payment.totalInstallments, let paidInstallments = payment.paidInstallments {
                Text("\(paidInstallments)/\(totalInstallments)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 10)
    }
}

struct PaymentRowView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentRowView(payment: Payment(name: "Example Payment", day: 15, type: .loan, monthlyPaymentAmount: 200.0, paidInstallments: 2, totalInstallments: 10))
            .previewLayout(.sizeThatFits)
    }
}
