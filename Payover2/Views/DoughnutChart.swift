import SwiftUI

struct DoughnutChart: View {
    @State private var totalIncome: Double = 100000
    @EnvironmentObject var viewModel: PaymentViewModel
    @State private var isEditingIncome: Bool = false
    @State private var incomeText: String = "100000"
    @State private var maxWidth: CGFloat = 0
    @State private var dots: [Dot] = []
    
    private var remainingMoney: Double {
        totalIncome - viewModel.totalPaymentAmount
    }
    
    private var hasNegativeBalance: Bool {
        remainingMoney < 0
    }
    
    var body: some View {
        VStack {
            ZStack {
                // Calculate dots for the chart
                DotShape(dots: $dots)
                    .onAppear {
                        dots = updateDotsColor(totalPaymentAmount: viewModel.totalPaymentAmount, income: totalIncome, dots: generateDots(totalIncome: totalIncome, totalPaymentAmount: viewModel.totalPaymentAmount))
                    }
                    .onChange(of: totalIncome) { newValue in
                        dots = updateDotsColor(totalPaymentAmount: viewModel.totalPaymentAmount, income: newValue, dots: generateDots(totalIncome: newValue, totalPaymentAmount: viewModel.totalPaymentAmount))
                    }
                    .onChange(of: viewModel.totalPaymentAmount) { newValue in
                        dots = updateDotsColor(totalPaymentAmount: newValue, income: totalIncome, dots: generateDots(totalIncome: totalIncome, totalPaymentAmount: newValue))
                    }
                
                // Display the amounts in the center of the doughnut
                VStack {
                    ZStack {
                        Text("\(Int(totalIncome)) ₺")
                            .opacity(isEditingIncome ? 0 : 1)
                            .onTapGesture {
                                incomeText = "\(Int(totalIncome))"
                                isEditingIncome = true
                            }
                        TextField("", text: Binding(
                            get: { self.incomeText },
                            set: {
                                if let _ = Double($0) {
                                    self.incomeText = $0
                                }
                            })
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                        .keyboardType(.decimalPad)
                        .opacity(isEditingIncome ? 1 : 0)
                        .onSubmit {
                            if let income = Double(incomeText) {
                                totalIncome = income
                            }
                            isEditingIncome = false
                        }
                    }
                    .frame(width: 100, height: 40) // Fixed size to prevent resizing
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.clear, lineWidth: 0)
                    )
                    
                    Text("-\(Int(viewModel.totalPaymentAmount)) ₺")
                        .background(GeometryReader { geometry in
                            Color.clear.onAppear {
                                let width = geometry.size.width
                                if width > maxWidth {
                                    maxWidth = width
                                }
                            }
                        })
                    Divider()
                        .frame(width: maxWidth)
                        .background(Color.black)
                    HStack {
                        Text("\(Int(remainingMoney)) ₺")
                            .foregroundColor(hasNegativeBalance ? .red : .primary)
                            .background(GeometryReader { geometry in
                                Color.clear.onAppear {
                                    let width = geometry.size.width
                                    if width > maxWidth {
                                        maxWidth = width
                                    }
                                }
                            })
                        if hasNegativeBalance {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .frame(width: 300, height: 300)
            .onTapGesture {
                // Dismiss the keyboard when tapping outside the text field
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                isEditingIncome = false
            }
        }
    }
    
    // Function to generate initial dot positions along a circular path
    func generateDots(totalIncome: Double, totalPaymentAmount: Double) -> [Dot] {
        var dots: [Dot] = []
        let innerRadius: CGFloat = 100
        let outerRadius: CGFloat = 150
        let center = CGPoint(x: 150, y: 150)
        let totalDots = 450 // Adjusted total number of dots
        
        while dots.count < totalDots {
            let angle = 270.0 - (Double(dots.count) / Double(totalDots) * 360.0) // Start from top and go counterclockwise
            let radians = angle * .pi / 180
            let distance = CGFloat.random(in: innerRadius..<outerRadius)
            let x = center.x + distance * cos(CGFloat(radians))
            let y = center.y + distance * sin(CGFloat(radians))
            let size = CGFloat.random(in: 4...8)
            
            let newDot = Dot(x: x, y: y, size: size, color: .gray)
            
            // Check for overlap
            if !isOverlapping(newDot: newDot, existingDots: dots) {
                dots.append(newDot)
            }
        }
        
        return dots // Do not shuffle to keep the order
    }
    
    // Function to check if a new dot overlaps with any existing dots
    func isOverlapping(newDot: Dot, existingDots: [Dot]) -> Bool {
        for dot in existingDots {
            let distance = sqrt(pow(newDot.x - dot.x, 2) + pow(newDot.y - dot.y, 2))
            if distance < (newDot.size + dot.size) / 2 {
                return true
            }
        }
        return false
    }
    
    // Function to update dot colors based on total payment amount and negative balance
    func updateDotsColor(totalPaymentAmount: Double, income: Double, dots: [Dot]) -> [Dot] {
        let totalDots = dots.count
        let paymentDotsCount = Int(min(totalPaymentAmount / income, 1) * Double(totalDots))
        let negativeBalanceDotsCount = totalPaymentAmount > income ? Int(((totalPaymentAmount - income) / income) * Double(totalDots)) : 0
        
        var updatedDots = dots
        
        // First, color the dots for the total payment amount
        for i in 0..<totalDots {
            if i < paymentDotsCount {
                updatedDots[i].color = .indigo
            } else {
                updatedDots[i].color = .gray
            }
        }
        
        // Then, color the red dots for the negative balance if any
        if negativeBalanceDotsCount > 0 {
            for i in 0..<negativeBalanceDotsCount {
                updatedDots[(paymentDotsCount + i) % totalDots].color = .red
            }
        }
        
        return updatedDots
    }
}
