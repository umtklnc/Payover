import SwiftUI

struct AddPaymentButton: View {
    @State private var isPresentingAddPaymentView = false
    
    var body: some View {
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
                        .environmentObject(PaymentViewModel())
                }
            }
        }
    }
}

struct AddPaymentButton_Previews: PreviewProvider {
    static var previews: some View {
        AddPaymentButton()
            .previewLayout(.sizeThatFits)
            .environmentObject(PaymentViewModel())
    }
}
