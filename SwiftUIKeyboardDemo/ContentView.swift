//
//  ContentView.swift
//  SwiftUIKeyboardDemo
//
//  Created by Emmanuel Crouvisier on 5/7/20.
//  Copyright © 2020 Emmanuel Crouvisier. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
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
        .keyCommand(
            KeyCommand(title: "First View", input: "1", modifierFlags: .command) { self.selection = 1 },
            KeyCommand(title: "Second View", input: "2", modifierFlags: .command) { self.selection = 2 }
        )
    }

        @State private var selection = 1
}

struct FirstView: View {

    let title = "First View"
    
    var body: some View {
        VStack {
            Text(title)
            Text("Hold down ⌘ to see keyboard shortcuts")
        }
    }
}

struct SecondView: View {

    let title = "Second View"
    
    var body: some View {
        VStack {
            Text(title)
            
            Button("Open Modal by tapping here or hitting ⌘-O") {
                self.isModalPresented.toggle()
            }
        }
        .keyCommand(isModalPresented ? dismissModalCommands : showModalCommands)
        .sheet(isPresented: $isModalPresented, content: {
            ModalView()
        })
    }

    private var showModalCommands: [KeyCommand] {
        [KeyCommand(title: "Open Modal", input: "O", modifierFlags: .command) { self.isModalPresented = true }]
    }

    private var dismissModalCommands: [KeyCommand] {
        let close = { self.isModalPresented = false }
        return [
            KeyCommand(title: "Close", input: "`", callback: close),
            KeyCommand(title: "", input: UIKeyCommand.inputEscape, callback: close),
            KeyCommand(title: "", input: "W", modifierFlags: .command, callback: close)
        ]
    }

    @State private var isModalPresented = false
}

struct ModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Modal View")
            Text("Hit ⌘-W, ⌘-., or Esc to close")
            Text("Note that two of the commands are hidden, thanks to empty titles")
        }
    }
}
