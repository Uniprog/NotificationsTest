//
//  ChatCoordinator+Route.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation

extension ChatCoordinator {
    
    func start(route: ChatCoordinator.Route) {
        switch route {
        case .showAsRoot:
            let viewController = ChatViewController.instantiate(storyboardName: "Chat")
            router.rootController?.viewControllers = [viewController]
        }
    }

}
