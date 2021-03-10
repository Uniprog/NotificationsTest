//
//  NotificationCell.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import UIKit

class NotificationCell: UITableViewCell {

    enum ImageType {
        case none
        case circle
        case rectangle
    }
    
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rectangleImageView: UIImageView!
    @IBOutlet weak var circleImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        unreadView.layer.cornerRadius = unreadView.bounds.size.height / 2
        circleImageView.layer.cornerRadius = circleImageView.bounds.size.height / 2
        rectangleImageView.layer.cornerRadius = 4
    }
}
