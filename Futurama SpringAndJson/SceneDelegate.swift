//
//  SceneDelegate.swift
//  Futurama SpringAndJson
//
//  Created by Nikita Shirobokov on 03.12.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
//        let alertFactory = CountriesAlertViewFactory()
//        let service = PersonService()
//        let dataSource = PersonsViewDataSource()
//        let presentor = PersonsPresentor(service: service,
//                                           dataSource: dataSource
//        )
//        let personViewController = PersonViewController(output: presentor)
//        presentor.view = personViewController
//        let rootNavigationController = UINavigationController(rootViewController: personViewController)
        let welcomeVC = WelcomeViewController()
        let rootNavigationController = UINavigationController(rootViewController: welcomeVC)
        window.rootViewController = rootNavigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}

