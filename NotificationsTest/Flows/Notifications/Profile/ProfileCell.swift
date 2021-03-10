//
//  ProfileCell.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 10/03/2021.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var mediasLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.height / 2
    }
}
