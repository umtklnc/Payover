import SwiftUI

struct TabButton: View {
    @Binding var selectedTab: Tab
    let tab: Tab
    let title: String
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            Text(title)
                .font(.system(size: 12)) // Adjust the font size
                .foregroundColor(selectedTab == tab ? .blue : .gray)
                .padding()
                .background(selectedTab == tab ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(8)
        }
    }
}

struct MainView: View {
    @State private var selectedTab: Tab = .all
    @EnvironmentObject var viewModel: PaymentViewModel
    @State private var isPresentingAddPaymentView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    DoughnutChart()
                        .padding()
                    
                    Spacer()
                    
                    // Navigation Bar
                    HStack {
                        TabButton(selectedTab: $selectedTab, tab: .all, title: "All")
                        TabButton(selectedTab: $selectedTab, tab: .loans, title: "Loans")
                        TabButton(selectedTab: $selectedTab, tab: .creditCard, title: "Cards")
                        TabButton(selectedTab: $selectedTab, tab: .subscriptions, title: "Subs")
                        TabButton(selectedTab: $selectedTab, tab: .others, title: "Others")
                    }
                    .padding()
                    
                    PaymentListView(paymentType: selectedTab.paymentType)
                        .environmentObject(viewModel)
                        .background(Color.white) // Ensure the background matches the main view
                    
                    Spacer()
                }
                .navigationBarHidden(true)
                .background(Color.white) // Set the same background color
                
                // Add Payment Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresentingAddPaymentView = true
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        .padding()
                        .sheet(isPresented: $isPresentingAddPaymentView) {
                            AddPaymentView()
                                .environmentObject(viewModel)
                        }
                    }
                }
            }
        }
    }
}

enum Tab {
    case all, loans, creditCard, subscriptions, others
    
    var paymentType: PaymentType? {
        switch self {
        case .all:
            return nil
        case .loans:
            return .loan
        case .creditCard:
            return .creditCard
        case .subscriptions:
            return .subscription
        case .others:
            return .other
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(PaymentViewModel())
    }
}
