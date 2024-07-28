import SwiftUI

struct DoughnutChartView: View {
    var payment: Payment
    
    var body: some View {
        // Replace this with your actual doughnut chart implementation
        Text("Doughnut Chart for \(payment.name)")
    }
}

struct DoughnutChartView_Previews: PreviewProvider {
    static var previews: some View {
        DoughnutChartView(payment: Payment(name: "Example Payment", day: 15, type: .loan, monthlyPaymentAmount: 200.0, paidInstallments: 2, totalInstallments: 10))
    }
}
