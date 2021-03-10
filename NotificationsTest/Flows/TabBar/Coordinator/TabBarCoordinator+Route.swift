//
//  TabBarCoordinator+Route.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation
import UIKit

extension TabBarCoordinator {
    
    func start(route: TabBarCoordinator.Route) {
        switch route {
        case .showTabs(let tabs):
            var viewControllers = [UIViewController]()
            var coordinators = [Coordinator]()

            for tab in tabs {
                switch tab {
                case .feed:
                    let navigationController = UINavigationController()
                    navigationController.title = "Feed"
                    let feedCoordinator = FeedCoordinator(router: Router(rootController: navigationController))
                    navigationController.isNavigationBarHidden = false
                    viewControllers.append(navigationController)
                    coordinators.append(feedCoordinator)
                case .chat:
                    let navigationController = UINavigationController()
                    navigationController.title = "Chat"
                    navigationController.isNavigationBarHidden = true
                    let chatCoordinator = ChatCoordinator(router: Router(rootController: navigationController))
                    viewControllers.append(navigationController)
                    coordinators.append(chatCoordinator)
                }
            }
            
            coordinators.forEach( { addDependency($0) } )
            tabBarViewController.viewControllers = viewControllers
            coordinators.forEach( { $0.start() } )
            
        case .selectTab(let tab):
            switch tab {
            case .feed:
                let coordinator = childCoordinators.first(where: { $0 is FeedCoordinator }) as? FeedCoordinator
                let rootController = coordinator?.router.rootController
                tabBarViewController.selectedViewController = rootController
            case .chat:
                let coordinator = childCoordinators.first(where: { $0 is ChatCoordinator }) as? ChatCoordinator
                let rootController = coordinator?.router.rootController
                tabBarViewController.selectedViewController = rootController
            }
        case .popToRoot:
            removeDependency(self)
            router.rootController?.popToRootViewController(animated: false)
            router.rootController?.dismiss(animated: false, completion: nil)
        }
    }
}
