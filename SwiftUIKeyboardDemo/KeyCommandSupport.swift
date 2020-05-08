import Foundation
import SwiftUI
import Combine

// MARK: - KeyCommandResponderHostingController

final class KeyCommandResponderHostingController: UIViewController {

    init<Content: View>(rootView: Content) {
        super.init(nibName: nil, bundle: nil)
        hostingController = UIHostingController(
            rootView: rootView
                .onPreferenceChange(KeyCommandsPreferenceKey.self) { [weak self] in
                    self?._keyCommands = $0
                }
        )
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hostingController.willMove(toParent: self)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }

    @objc fileprivate func handleKeyCommand(_ sender: KeyCommand) {
        sender.callback()
    }

    override var keyCommands: [UIKeyCommand]? {
        _keyCommands
    }

    private var _keyCommands: [UIKeyCommand]?

    private var hostingController: UIViewController!
}

// MARK: - KeyCommand

final class KeyCommand: UIKeyCommand {
    var callback: () -> Void = {}
}

extension KeyCommand {
    convenience init(
        title: String,
        image: UIImage? = nil,
        input: String,
        modifierFlags: UIKeyModifierFlags = [],
        propertyList: Any? = nil,
        alternates: [UICommandAlternate] = [],
        discoverabilityTitle: String? = nil,
        attributes: UIMenuElement.Attributes = [],
        state: UIMenuElement.State = .off,
        callback: @escaping () -> Void
    ) {
        self.init(
            title: title,
            image: image,
            action: #selector(KeyCommandResponderHostingController.handleKeyCommand),
            input: input,
            modifierFlags: modifierFlags,
            propertyList: propertyList,
            alternates: alternates,
            discoverabilityTitle: discoverabilityTitle,
            attributes: attributes,
            state: state
        )
        self.callback = callback
    }
}

extension View {
    func keyCommand(_ keyCommands: KeyCommand...) -> some View {
        keyCommand(keyCommands)
    }

    func keyCommand(_ keyCommands: [KeyCommand]) -> some View {
        transformPreference(KeyCommandsPreferenceKey.self) {
            $0.append(contentsOf: keyCommands)
        }
    }
}

private enum KeyCommandsPreferenceKey: PreferenceKey {
    static var defaultValue: [KeyCommand] = []

    static func reduce(value: inout [KeyCommand], nextValue: () -> [KeyCommand]) {
        value.append(contentsOf: nextValue())
    }
}
