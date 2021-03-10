//
//  ProfileViewController.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 10/03/2021.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var onBackClick: (() -> Void)?
        
    private enum Section {
        case profile(GTUser)
        case medias([GTMedia])
    }
    
    private var sections = [Section]()
    
    private enum Constants {
        enum Profile {
            static let cellHeight = 262
        }
        enum Media {
            static let mediasPerRow = 2
            static let cellHeight = 248
        }
    }
    
    var viewModel: ProfileViewModelProtocol? {
        didSet {
            updateData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // TODO: Bind to view model updates
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        onBackClick?()
    }
    
    func updateData() {
        guard view != nil else {
            return
        }
        guard let viewModel = viewModel else {
            navigationTitleLabel.text = ""
            sections.removeAll()
            collectionView.reloadData()
            return
        }
        
        navigationTitleLabel.text = viewModel.user.name?.uppercased()
        
        sections = [.profile(viewModel.user),
                    .medias(viewModel.medias)]
        
        collectionView.reloadData()
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .profile(_):
            return 1
        case .medias(let medias):
            return medias.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .profile(let user):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
                fatalError() // TODO: Move to extension
            }
            configure(cell, user: user)
            return cell
        case .medias(let medias):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as? MediaCell else {
                fatalError() // TODO: Move to UICollectionView extension
            }
            let media = medias[indexPath.item]
            configure(cell, media: media)
            return cell
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let width = collectionView.bounds.width
        let spacing = flowLayout.minimumInteritemSpacing
        let sectionInset = flowLayout.sectionInset
        let contentInset = collectionView.contentInset
        var availableWidth = width - sectionInset.left - sectionInset.right
        availableWidth = availableWidth - contentInset.left - contentInset.right
        
        let section = sections[indexPath.section]
        switch section {
        case .profile(_):
            return CGSize(width: availableWidth, height: CGFloat(Constants.Profile.cellHeight))
        case .medias(_):
            availableWidth -= spacing * CGFloat(Constants.Media.mediasPerRow - 1)
            let itemWidth = floor(availableWidth / CGFloat(Constants.Media.mediasPerRow))
            return CGSize(width: itemWidth, height: CGFloat(Constants.Media.cellHeight))
        }
    }
}

extension ProfileViewController {
    func configure(_ cell: ProfileCell, user: GTUser) {
        guard let viewModel = viewModel else {
            return
        }
        cell.avatarImageView.sd_setImage(with: URL(string: user.avatar?.url ?? ""), completed: nil)
        
        // TODO: Add localization
        let mediasCount = viewModel.getMediasCount(for: user)
        if mediasCount == 1 {
            cell.mediasLabel.text = "\(mediasCount) video"
        } else {
            cell.mediasLabel.text = "\(mediasCount) videos"
        }
        
        let followersCount = viewModel.getFolloersCount(for: user)
        if followersCount == 1 {
            cell.followersLabel.text = "\(followersCount) follower"
        } else {
            cell.followersLabel.text = "\(followersCount) followers"
        }
        
        let followingCount = viewModel.getFollowingCount(for: user)
        cell.followingLabel.text = "\(followingCount) following"
    }
    
    func configure(_ cell: MediaCell, media: GTMedia) {
        // TODO: Add media cell config
    }
}
