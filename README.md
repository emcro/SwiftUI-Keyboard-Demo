# SwiftUI-Keyboard-Demo

This tiny project was built to show how simple it is to add keyboard shortcuts (with UIKeyCommand) to any SwiftUI app.
After implementing the main parts below, you'll have the hold-down-⌘ button work in all of the views where you want to
support it, listing out every keyboard shortcut available to the user. The user expects it, don't let them down!

![⌘ Key Preview](http://cln.sh/lpJS+)

## Full working example for basic tab switching

If all you want to do is add add Cmd-1, Cmd-2, etc keyboard shortcuts to active different tabs, literally all you need is the following:

### AppDelegate
* Add `override var keyCommands` which returns an array of `UIKeyCommand`, and a handler to handle those using NotificationCenter

```
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
```

### ContentView
* Add `onReceive` to handle the posted Notification and use the `selection` binding to jump to the correct tab

```
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
```

----

In the full demo, I also show how you can use an `ObservableObject` and state for a more complicated example, to allow for opening and closing modals, using hidden keyboard shortcuts, etc, but the basics are the same. The app will always look 
to the `keyCommands` defined in the AppDelegate, so based on the user's current view, you would simply return a 
different array of `UIKeyCommand`s.

There's a more thorough walkthrough that I'll be writing up on Medium soon, but I wanted to get this out there as soon as 
possible as I couldn't find *any* solution through Google or asking some of the great SwiftUI fans on Twitter and 
elsewhere for a clean way to do this. I purposely provided a few different methods to help you find the best way to 
integrate these keyboard shortcuts in your apps, and urge you to *please* add them ASAP. It's just behind adding 
accessibility to an app in my view, especially with the amazing new Magic Keyboard for iPad Pro, you likely have a lot 
more users now who will be looking for keyboard shortcuts in your iPad app.

## Invisible Keyboard Shortcuts
One more cool thing in here is adding "invisible" shortcuts by leaving the title of your `UIKeyCommand` empty, 
as you can see implemented for modals. *Please* add support for the universal methods to close any kind of modal 
and make the iPad world a better place, ⌘-W and Esc (which will also give you ⌘-. for free, as it sends Esc when used):

```
UIKeyCommand(title: "", action: #selector(handleKeyCommand(sender:)), input: UIKeyCommand.inputEscape, propertyList: "closeModal"),
UIKeyCommand(title: "", action: #selector(handleKeyCommand(sender:)), input: "W", modifierFlags: .command, propertyList: "closeModal")
```

## Users-Will-Love-You Keyboard Shortcut
I also added in the backtick, as that is where Esc would normally be on a US keyboard, after seeing 
the always-awesome-and-funny [Christian Selig](https://twitter.com/ChristianSelig) add it into his equally awesome Apollo app 
for Reddit and though it was just too damn clever not use myself in my app:

```
UIKeyCommand(title: "Close", action: #selector(handleKeyCommand(sender:)), input: "`", propertyList: "closeModal")

```

## Try it out in the App Store with CardPointers
Speaking of which, shameless plug ahead: if you have a credit card or you're looking for your first one(s) to help get the 
most cash back or points/miles to make traveling ridiculously cheap/free, or if you just want to play with a free live 
app in the App Store that's using these exact same keyboard shortcut techniques, grab 
[CardPointers](https://apps.apple.com/us/app/cardpointers/id1472875808) from the App Store, you'll be happy you did.

## Contact/PRs/Issues
PRs are most welcome and I'll do my best to answer any questions; best way to reach me is through Twitter 
[@emcro](https://twitter.com/emcro).
