//
//  SceneDelegate.swift
//  SwiftUIKeyboardDemo
//
//  Created by Emmanuel Crouvisier on 5/7/20.
//  Copyright © 2020 Emmanuel Crouvisier. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = KeyCommandResponderHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

