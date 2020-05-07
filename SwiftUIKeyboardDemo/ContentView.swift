//
//  ContentView.swift
//  SwiftUIKeyboardDemo
//
//  Created by Emmanuel Crouvisier on 5/7/20.
//  Copyright © 2020 Emmanuel Crouvisier. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection){
            FirstView().tabItem {
                VStack {
                    Image("first")
                    Text("First")
                }
            }
            .tag(1)
            
            SecondView().tabItem {
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

struct FirstView: View {
    @EnvironmentObject var store: Store
    
    let title = "First View"
    
    var body: some View {
        VStack {
            Text(title)
            Text("Hold down ⌘ to see keyboard shortcuts")
        }
        .onAppear {
            self.store.currentView = self.title
        }
    }
}

struct SecondView: View {
    @EnvironmentObject var store: Store
    @State private var isPresented = false
    
    let title = "Second View"
    
    var body: some View {
        VStack {
            Text(title)
            
            Button("Open Modal by tapping here or hitting ⌘-O") {
                self.store.openSecondViewModal.toggle()
            }
        }
        .onAppear {
            self.store.currentView = self.title
        }
        .sheet(isPresented: self.$store.openSecondViewModal, content: {
            ModalView().environmentObject(self.store)
        })
    }
}

struct ModalView: View {
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Modal View")
            Text("Hit ⌘-W, ⌘-., or Esc to close")
            Text("Note that two of the commands are hidden, thanks to empty titles")
        }
        .onAppear {
            self.store.isModalPresented = true
        }
        .onDisappear {
            self.store.isModalPresented = false
        }
        .onReceive(store.$dismissModal, perform: { dismissModal in
            if dismissModal {
                self.presentationMode.wrappedValue.dismiss()
                self.store.dismissModal = false
            }
        })
    }
}

final class Store: ObservableObject {
    @Published var isModalPresented: Bool = false
    @Published var openSecondViewModal: Bool = false
    @Published var dismissModal: Bool = false
    @Published var currentView: String = ""
}
