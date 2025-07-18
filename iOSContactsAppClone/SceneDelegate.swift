//
//  SceneDelegate.swift
//  iOSContactsAppClone
//
//  Created by Ferid on 04.07.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: ContactListViewController())
        self.window = window
        window.makeKeyAndVisible()
    }
}
