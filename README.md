# SwiftUI-Keyboard-Demo

This tiny project was built to show how simple it is to add keyboard shortcuts (with UIKeyCommand) to any SwiftUI app.
After implementing the main parts below, you'll have the hold-down-⌘ button work in all of the views where you want to
support it, listing out every keyboard shortcut available to the user. The user expects it, don't let them down!

![⌘ Key Preview](http://cln.sh/lpJS+)

The key components:

### AppDelegate

```
override var keyCommands: [UIKeyCommand]? {
  return [UIKeyCommand(title: "Title", action: #selector(handleKeyCommand(sender:)), input: "1", modifierFlags: .command, propertyList: 1)]
}

@objc func handleKeyCommand(sender: UIKeyCommand) {
  // Handle the keyboard shortcuts via NotificationCenter, updating state through an ObservableObject, etc.
}
```

### SwiftUI Views
```
.onReceive(<Binding, NotificationCenter, etc>, perform: { action in
  if action {
    // Perform some action, such as switching to a different tab, closing a modal, etc
    }
}
```

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
UIKeyCommand(title: "Close", action: #selector(handleKeyCommand(sender:)), input: "`", propertyList: "closeModal"),

```

## Try it out in the App Store with CardPointers
Speaking of which, shameless plug ahead: if you have a credit card or you're looking for your first one(s) to help get the 
most cash back or points/miles to make traveling ridiculously cheap/free, or if you just want to play with a free live 
app in the App Store that's using these exact same keyboard shortcut techniques, grab 
[CardPointers](https://apps.apple.com/us/app/cardpointers/id1472875808) from the App Store, you'll be happy you did.

## Contact/PRs/Issues
PRs are most welcome and I'll do my best to answer any questions; best way to reach me is through Twitter 
[@emcro](https://twitter.com/emcro).
