import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: PaymentViewModel
    
    var body: some View {
        MainView()
            .environmentObject(viewModel) // Ensure the environment object is passed down
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PaymentViewModel())
    }
}
