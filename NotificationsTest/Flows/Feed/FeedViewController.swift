//
//  FeedViewController.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import UIKit

class FeedViewController: UIViewController {

    var onNotificationsButtonClick: (() -> Void)?
    
    // TODO: Temporary solution to load mock data
    let service = NotificationsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let notificationsBarButtonItem = UIBarButtonItem(title: "Notif",
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(notificationsButtonClicked))
        
        self.navigationItem.setRightBarButton(notificationsBarButtonItem, animated: false)
        navigationItem.title = "Test"
        
        // Temporary solution
        if service.getNotifications().isEmpty {
            saveMockNotifications()
        }
    }
    
    @objc func notificationsButtonClicked() {
        onNotificationsButtonClick?()
    }
    
    @IBAction func onDefaultNotificationsClick(_ sender: Any) {
        saveMockNotifications()
    }
}


extension FeedViewController {
    
    func saveMockNotifications() {
        
        var imageUrl: String
        var user: GTUser
        var media: GTMedia
        var type: GTNotification.GTType
        var notification: GTNotification
        var checkOut: GTCheckOut
        
        service.save([])
        
        user = GTUser(id: UUID().uuidString, name: "Matteo", avatar: nil)
        imageUrl = Bundle.main.url(forResource: "image1", withExtension: "png")?.absoluteString ?? ""
        media = GTMedia(type: .photo, url: imageUrl)
        type = .liked(user: user, media: media)
        notification = GTNotification(id: UUID().uuidString, type: type, updatedAt: Date.init(timeIntervalSinceNow: -1))
        service.save(notification)
        
        imageUrl = Bundle.main.url(forResource: "image2", withExtension: "png")?.absoluteString ?? ""
        media = GTMedia(type: .photo, url: imageUrl)
        user = GTUser(id: UUID().uuidString, name: "matias", avatar: media)
        type = .following(user)
        notification = GTNotification(id: UUID().uuidString, type: type, updatedAt: Date.init(timeIntervalSinceNow: -2))
        service.save(notification)
        
        imageUrl = Bundle.main.url(forResource: "image3", withExtension: "png")?.absoluteString ?? ""
        media = GTMedia(type: .photo, url: imageUrl)
        user = GTUser(id: UUID().uuidString, name: "matias", avatar: nil)
        checkOut = GTCheckOut.challenge(GTChallenge(type: .new, media: media), name: nil)
        type = .checkOut(checkOut)
        notification = GTNotification(id: UUID().uuidString, type: type, updatedAt: Date.init(timeIntervalSinceNow: -3))
        service.save(notification)
        
        imageUrl = Bundle.main.url(forResource: "image4", withExtension: "png")?.absoluteString ?? ""
        media = GTMedia(type: .photo, url: imageUrl)
        user = GTUser(id: UUID().uuidString, name: "matias", avatar: nil)
        checkOut = GTCheckOut.challenge(GTChallenge(type: .new, media: media), name: "Toilet Paper Challenge")
        type = .checkOut(checkOut)
        notification = GTNotification(id: UUID().uuidString, type: type, updatedAt: Date.init(timeIntervalSinceNow: -4))
        notification.isUnread = false
        service.save(notification)
        
        imageUrl = Bundle.main.url(forResource: "image5", withExtension: "png")?.absoluteString ?? ""
        media = GTMedia(type: .photo, url: imageUrl)
        user = GTUser(id: UUID().uuidString, name: "Anton", avatar: media)
        checkOut = GTCheckOut.user(user)
        type = .checkOut(checkOut)
        notification = GTNotification(id: UUID().uuidString, type: type, updatedAt: Date.init(timeIntervalSinceNow: -5))
        notification.isUnread = false
        service.save(notification)
        
        imageUrl = Bundle.main.url(forResource: "image6", withExtension: "png")?.absoluteString ?? ""
        media = GTMedia(type: .video, url: imageUrl)
        user = GTUser(id: UUID().uuidString, name: "Anton", avatar: nil)
        type = .recommendation(.media(media))
        notification = GTNotification(id: UUID().uuidString, type: type, updatedAt: Date.init(timeIntervalSinceNow: -6))
        notification.isUnread = false
        service.save(notification)
     
        imageUrl = Bundle.main.url(forResource: "image7", withExtension: "png")?.absoluteString ?? ""
        media = GTMedia(type: .photo, url: imageUrl)
        user = GTUser(id: UUID().uuidString, name: "Mary", avatar: media)
        type = .recommendation(.user(user))
        notification = GTNotification(id: UUID().uuidString, type: type, updatedAt: Date.init(timeIntervalSinceNow: -7))
        notification.isUnread = false
        service.save(notification)
    }
}
