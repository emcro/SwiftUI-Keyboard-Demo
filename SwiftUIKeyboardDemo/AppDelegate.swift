//
//  AppDelegate.swift
//  SwiftUIKeyboardDemo
//
//  Created by Emmanuel Crouvisier on 5/7/20.
//  Copyright © 2020 Emmanuel Crouvisier. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let store = Store()
    
    override var keyCommands: [UIKeyCommand]? {
        var commands: [UIKeyCommand] = []
        
        if store.isModalPresented {
            commands += [
                UIKeyCommand(title: "Close", action: #selector(handleKeyCommand(sender:)), input: "`", propertyList: "closeModal"),
                UIKeyCommand(title: "", action: #selector(handleKeyCommand(sender:)), input: UIKeyCommand.inputEscape, propertyList: "closeModal"),
                UIKeyCommand(title: "", action: #selector(handleKeyCommand(sender:)), input: "W", modifierFlags: .command, propertyList: "closeModal")
            ]
        } else {
            commands += [
                UIKeyCommand(title: "First View", action: #selector(handleKeyCommand(sender:)), input: "1", modifierFlags: .command, propertyList: 1),
                
                UIKeyCommand(title: "Second View", action: #selector(handleKeyCommand(sender:)), input: "2", modifierFlags: .command, propertyList: 2)
            ]
            
            // Add an Open Modal shortcut just when the second view is on screen
            if store.currentView == "Second View" {
                commands.append(UIKeyCommand(title: "Open Modal", action: #selector(handleKeyCommand(sender:)), input: "O", modifierFlags: .command, propertyList: "openModal"))
            }
        }
        
        return commands
    }
    
    @objc func handleKeyCommand(sender: UIKeyCommand) {
        if let tabTag = sender.propertyList as? Int {
            NotificationCenter.default.post(name: .init("switchTabs"), object: tabTag)
            return
        }
        
        if let propertyList = sender.propertyList as? String {
            switch propertyList {
            case "openModal":
                self.store.openSecondViewModal = true
                return
                
            case "closeModal":
                self.store.dismissModal = true
                return
                
            default:
                return
            }
        }
    }
}
