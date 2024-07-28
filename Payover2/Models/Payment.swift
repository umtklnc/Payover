import Foundation

enum PaymentType: String, Codable {
    case loan = "Loan"
    case creditCard = "Credit Card"
    case subscription = "Subscription"
    case other = "Other"
}

struct Payment: Identifiable, Codable {
    let id: UUID
    var name: String
    var day: Int
    var type: PaymentType
    var monthlyPaymentAmount: Double
    var paidInstallments: Int?
    var totalInstallments: Int?
    var isEndless: Bool

    init(name: String, day: Int, type: PaymentType, monthlyPaymentAmount: Double, paidInstallments: Int? = nil, totalInstallments: Int? = nil, isEndless: Bool = false) {
        self.id = UUID()
        self.name = name
        self.day = day
        self.type = type
        self.monthlyPaymentAmount = monthlyPaymentAmount
        self.paidInstallments = paidInstallments
        self.totalInstallments = totalInstallments
        self.isEndless = isEndless
    }
    
    var totalDebt: Double {
        return (monthlyPaymentAmount) * Double(totalInstallments ?? 0)
    }
    
    var remainingDebt: Double {
        return (monthlyPaymentAmount) * Double((totalInstallments ?? 0) - (paidInstallments ?? 0))
    }
}
