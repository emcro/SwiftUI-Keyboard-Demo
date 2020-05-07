import SwiftUI

struct ContentView: View {
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection){
            Text("First View")
                .tabItem {
                    VStack {
                        Image("first")
                        Text("First")
                    }
            }
            .tag(1)
            
            Text("Second View")
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Second")
                    }
            }
            .tag(2)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("switchTabs"))) { notification in
            if let tabTag = notification.object as? Int {
                self.selection = tabTag
            }
        }
    }
}
