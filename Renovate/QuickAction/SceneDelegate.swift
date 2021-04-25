//
//  SceneDelegate.swift
//  Renovate
//
//  Created by T  on 2021-04-25.
//

import SwiftUI

// This is only called when App is already working
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    @Environment(\.openURL) var openURL

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let shortcutItem = connectionOptions.shortcutItem {
            guard let url = URL(string: shortcutItem.type) else {
                print("scene: can't find shortcutItem")
                return
            }

            openURL(url)
        } else {
            print("scene: connectionOptions.shortcutItem doesn't exit")
        }
    }


    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        guard let url = URL(string: shortcutItem.type) else {
            print("windowScene: can't find shortcutItem")
            completionHandler(false)
            return
        }

        openURL(url, completion: completionHandler)
    }
    
}
