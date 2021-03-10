//
//  NotificationsCoordinator.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation

class NotificationsCoordinator: Coordinator {
    let router:Routerable
    
    var finishedFlow:((_ sender: NotificationsCoordinator) -> Void)?

    init(router:Routerable) {
        self.router = router
    }
    
    override func start() {
        start(route: .showAsRoot)
    }
}

extension NotificationsCoordinator {
    enum Route {
        case showAsRoot
        case showProfile(GTUser)
    }
}
