//
//  NotificationsListViewModel.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 10/03/2021.
//

import Foundation

protocol NotificationsListViewModelProtocol {
    // Input
    func loadNotifications()
    func markAsRead(_ notification: GTNotification)
    
    // Output
    var notifications: [GTNotification] { get }
    var didUpdateNotifications: (() -> Void)? { get set }
}

class NotificationsListViewModel: NotificationsListViewModelProtocol {
    
    // TODO: Inject on init
    // TODO: Use DB to store data
    private let localNotificationService = NotificationsService()
    
    // TODO: Add remote service
    
    private(set) var notifications = [GTNotification]()
    
    var didUpdateNotifications: (() -> Void)?
    
    func loadNotifications() {
        notifications = localNotificationService.getNotifications()
        didUpdateNotifications?()
    }
    
    func markAsRead(_ notification: GTNotification) {
        var notif = notification
        notif.isUnread = false
        localNotificationService.save(notif)
        loadNotifications()
    }
}

// TODO: move to separate file, add protocol
// TODO: Use DB to store data
struct NotificationsService {
    
    private enum Constants {
        static let storageKey = "LocalStoredNotifications"
    }
    func getNotifications() -> [GTNotification] {
        return UserDefaults.standard.load(forKey: Constants.storageKey) ?? []
    }
    
    func save(_ notifications: [GTNotification]) {
        UserDefaults.standard.save(notifications, forKey: Constants.storageKey)
        UserDefaults.standard.synchronize()
    }
    
    func getNotification(id: String) -> GTNotification? {
        let notifications = getNotifications()
        return notifications.first { $0.id == id }
    }
    
    func save(_ notification: GTNotification) {
        var notifications = getNotifications()
        notifications.removeAll { $0.id == notification.id }
        notifications.append(notification)
        save(notifications)
    }
    
    func deleteNotification(id: String) {
        var notifications = getNotifications()
        notifications.removeAll { $0.id == id }
    }
}
