//
//  NotificationsListViewController.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import UIKit
import SDWebImage

class NotificationsListViewController: UIViewController {

    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var onCloseClick: (() -> Void)?
    var onNotoificationSelect: ((NotificationsListViewController,
                                 NotificationsListViewModelProtocol,
                                 GTNotification) -> Void)?
    
    // TODO: Inject view model
    var viewModel: NotificationsListViewModelProtocol = NotificationsListViewModel()
    
    private var notifications = [GTNotification]()
    
    private enum Constants {
        static let cellReuseIdentifier = "NotificationCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadNotifications()
    }

    func bind() {
        viewModel.didUpdateNotifications = { [weak self] in
            self?.updateData()
        }
    }
    
    func updateData() {
        notifications = viewModel.notifications
        // Sort by unread and date
        // Unread always on top
        notifications.sort(by: { $0.isUnread && !$1.isUnread },
                           { $0.updatedAt > $1.updatedAt })
        tableView.reloadData()
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        onCloseClick?()
    }
}

extension NotificationsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier,
                                                       for: indexPath) as? NotificationCell else {
            // TODO: Move this to UITableView extension
            fatalError("Can't dequeue reusable cell with identifier \(Constants.cellReuseIdentifier)")
        }
        
        let notification = notifications[indexPath.row]
        configure(cell: cell, with: notification)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notification = notifications[indexPath.row]
        onNotoificationSelect?(self, viewModel, notification)
    }
}

extension NotificationsListViewController {
    
    func configure(cell: NotificationCell, with notification: GTNotification) {
        
        cell.unreadView.isHidden = !notification.isUnread
        
        // Formatted message
        cell.messageLabel.attributedText = notificationMessage(notification)
        
        // Photo config
        cell.circleImageView.isHidden = true
        cell.rectangleImageView.isHidden = true
        cell.circleImageView.image = nil
        cell.rectangleImageView.image = nil
        
        let photoInfo = mediaInfo(for: notification)
        switch photoInfo {
        case (.none, _):
            break
        case (.circle, let media):
            if let media = media {
                cell.circleImageView.isHidden = false
                cell.circleImageView.sd_setImage(with: URL(string: media.url), completed: nil)
            }
        case (.rectangle, let media):
            if let media = media {
                cell.rectangleImageView.isHidden = false
                cell.rectangleImageView.sd_setImage(with: URL(string: media.url), completed: nil)
            }
        }
    }
    
    func mediaInfo(for notification: GTNotification) -> (NotificationCell.ImageType, GTMedia?) {
        switch notification.type {
        case .liked( _, let media):
            return (.rectangle, media)
        case .following(let user):
            return (.circle, user.avatar)
        case .checkOut(let checkout):
            switch checkout {
            case .challenge(let challenge, name: _):
                return (.rectangle, challenge.media)
            case .user(let user):
                return (.circle, user.avatar)
            }
        case .recommendation(let recommendation):
            switch recommendation {
            case .media(let media):
                return (.rectangle, media)
            case .user(let user):
                return (.circle, user.avatar)
            }
        }
    }
    
    // TODO: Add localization
    func notificationMessage(_ notification: GTNotification) -> NSAttributedString {
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.black,
                                                          .font: UIFont.openSans(type: .regular, size: 15) as Any]
        let attributesBold: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.black,
                                                              .font: UIFont.openSans(type: .bold, size: 15) as Any]
        let string = NSMutableAttributedString()
        
        switch notification.type {
        case .liked(let user, _):
            string.append(NSAttributedString(string: user.name ?? "", attributes: attributesBold))
            string.append(NSAttributedString(string: " " + "liked your video", attributes: attributes))
        case .following(let user):
            string.append(NSAttributedString(string: user.name ?? "", attributes: attributesBold))
            string.append(NSAttributedString(string: " " + "is now following you", attributes: attributes))
        case .checkOut(let checkout):
            switch checkout {
            case .challenge(_, let name):
                if let name = name {
                    string.append(NSAttributedString(string: "New" + " ", attributes: attributes))
                    string.append(NSAttributedString(string: "\(name).", attributes: attributesBold))
                    string.append(NSAttributedString(string: " " + "Check it out!", attributes: attributes))
                } else {
                    string.append(NSAttributedString(string: "There's a new challenge for you to check out", attributes: attributes))
                }
            case .user(let user):
                string.append(NSAttributedString(string: "Check out" + " ", attributes: attributes))
                string.append(NSAttributedString(string: "\(user.name ?? "")", attributes: attributesBold))
                string.append(NSAttributedString(string: "'s", attributes: attributes))
                string.append(NSAttributedString(string: " " + "profile", attributes: attributes))
            }
        case .recommendation(let recommendation):
            switch recommendation {
            case .media(let media):
                string.append(NSAttributedString(string: "Here is a" + " ", attributes: attributes))
                string.append(NSAttributedString(string: "new \(media.type.rawValue)", attributes: attributesBold))
                string.append(NSAttributedString(string: " " + "we like", attributes: attributes))
            case .user(_ ):
                string.append(NSAttributedString(string: "Here is a" + " ", attributes: attributes))
                string.append(NSAttributedString(string: "profile", attributes: attributesBold))
                string.append(NSAttributedString(string: " " + "we like", attributes: attributes))
            }
        }
        
        return string
    }
}
