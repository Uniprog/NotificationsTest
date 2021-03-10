//
//  AppCoordinator+Notifications.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation
import UIKit

extension AppCoordinator {
    
    func start(route: AppCoordinator.Route.Notifications) {
        switch route {
        case .presentNotifications:
            let navigationController = UINavigationController()
            navigationController.isNavigationBarHidden = true
            let coordinator = NotificationsCoordinator(router: Router(rootController: navigationController))
            coordinator.finishedFlow = {[weak self] sender in
                self?.router.dismissModule(animated: true, completion: {
                    self?.removeDependency(sender)
                })
            }
            
            router.present(navigationController, animated: true)
            
            addDependency(coordinator)
            coordinator.start()
        }
    }
}
