import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(title: "First Tab", action: #selector(handleKeyCommand(sender:)), input: "1", modifierFlags: .command, propertyList: 1),
            
            UIKeyCommand(title: "Second Tab", action: #selector(handleKeyCommand(sender:)), input: "2", modifierFlags: .command, propertyList: 2)
        ]
    }
    
    @objc func handleKeyCommand(sender: UIKeyCommand) {
        if let tabTag = sender.propertyList as? Int {
            NotificationCenter.default.post(name: .init("switchTabs"), object: tabTag)
        }
    }
}
