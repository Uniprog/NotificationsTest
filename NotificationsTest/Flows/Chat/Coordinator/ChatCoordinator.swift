//
//  ChatCoordinator.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation

class ChatCoordinator: Coordinator {
    let router:Routerable
    
    init(router:Routerable) {
        self.router = router
    }
    
    override func start() {
        start(route: .showAsRoot)
    }
}

extension ChatCoordinator {
    enum Route {
        case showAsRoot
    }
}
