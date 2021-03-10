//
//  NotificationsCoordinator+Route.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation
import UIKit

extension NotificationsCoordinator {
    
    func start(route: NotificationsCoordinator.Route) {
        switch route {
        case .showAsRoot:
            let viewController: NotificationsListViewController =
                NotificationsListViewController.instantiate(storyboardName: "Notifications")
            
            viewController.onCloseClick = { [weak self] in
                guard let self = self else {
                    return
                }
                self.finishedFlow?(self)
            }
            
            viewController.onNotoificationSelect = { [weak self] viewController, viewModel, notification in
                
                if let user = self?.userToDisplay(for: notification) {
                    self?.start(route: .showProfile(user))
                    if notification.isUnread {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.markAsRead(notification)
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Application can't open that type of notification",
                                                            message: "Details screen is not ready",
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                        if notification.isUnread {
                            viewModel.markAsRead(notification)
                        }
                    }
                    
                    alertController.addAction(okAction)
                    self?.router.present(alertController)
                }
            }
            
            router.rootController?.viewControllers = [viewController]
        
        case .showProfile(let user):
            
            let viewModel = ProfileViewModel(user: user)
            // TODO: load real medias in view model
            viewModel.medias = [GTMedia(type: .photo, url: ""),
                                GTMedia(type: .photo, url: ""),
                                GTMedia(type: .photo, url: ""),
                                GTMedia(type: .photo, url: ""),
                                GTMedia(type: .photo, url: ""),]
            let viewController: ProfileViewController = ProfileViewController.instantiate(storyboardName: "Profile")
            viewController.viewModel = viewModel
            viewController.onBackClick = { [weak self] in
                self?.router.popModule(animated: true)
            }
            
            router.push(viewController, animated: true)
        }
    }
}


extension NotificationsCoordinator {
    func userToDisplay(for notification: GTNotification) -> GTUser? {
        switch notification.type {
        case .liked(_, _):
            return nil
        case .following(let user):
            return user
        case .checkOut(let checkOut):
            switch checkOut {
            case .challenge(_, _):
                return nil
            case .user(let user):
                return user
            }
        case .recommendation(let recommendation):
            switch recommendation {
            case .media(_):
                return nil
            case .user(let user):
                return user
            }
        }
    }
}
