//
//  FeedCoordinator.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation

class FeedCoordinator: Coordinator {
    let router:Routerable
    
    init(router:Routerable) {
        self.router = router
    }
    
    override func start() {
        start(route: .showAsRoot)
    }
}

extension FeedCoordinator {
    enum Route {
        case showAsRoot
    }
}
