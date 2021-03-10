//
//  AppCoordinator+Route.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation

extension AppCoordinator {
    
    func start(route: AppCoordinator.Route) {
        switch route {
        case .showTabBarAsRoot:
            let tabBarController = TabBarViewController()
            let tabBarCoordinator = TabBarCoordinator(router: router, tabBarViewController: tabBarController)
            addDependency(tabBarCoordinator)
            router.setRootModule(tabBarController, hideBar: true)
            tabBarCoordinator.start()
        case .clear:
            removeDependency(self)
            router.rootController?.viewControllers = []
            router.rootController?.dismiss(animated: false, completion: nil)
            router.rootController?.children.forEach( { router.removeChild($0, animated: false) })
        case .popToRoot:
            removeDependency(self)
            router.rootController?.popToRootViewController(animated: false)
            router.rootController?.dismiss(animated: false, completion: nil)
        }
    }
}



