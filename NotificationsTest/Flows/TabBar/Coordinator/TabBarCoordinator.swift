//
//  TabBarCoordinator.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation
import UIKit

class TabBarCoordinator: Coordinator {
    
    let router: Routerable
    let tabBarViewController: UITabBarController

    init(router:Routerable, tabBarViewController: UITabBarController) {
        self.router = router
        self.tabBarViewController = tabBarViewController
    }
    
    override func start() {
        start(route: .showTabs(tabs: [.feed, .chat]))
    }
}

extension TabBarCoordinator {
    enum Tab {
        case feed
        case chat
    }
}

extension TabBarCoordinator {
    enum Route {
        case showTabs(tabs:[Tab])
        case selectTab(tab:Tab)
        case popToRoot
    }
}
