import SwiftUI

struct SecondView: View {
    var body: some View {
        VStack {
            Text("新功能页面")
                .font(.largeTitle)
            
            Text("这里将开发新的功能")
                .foregroundColor(.gray)
                .padding()
            
            Spacer()
        }
        .navigationTitle("新功能")
    }
}

#Preview {
    NavigationStack {
        SecondView()
    }
} 
