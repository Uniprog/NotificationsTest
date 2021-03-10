//
//  ProfileViewModel.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 10/03/2021.
//

import Foundation

protocol ProfileViewModelProtocol {
    var user: GTUser { get }
    var medias: [GTMedia] { get }
    
    func getMediasCount(for user: GTUser) -> Int
    func getFolloersCount(for user: GTUser) -> Int
    func getFollowingCount(for user: GTUser) -> Int
    
    // TODO: Add pagination for medias
}

class ProfileViewModel: ProfileViewModelProtocol {
    var user: GTUser
    var medias = [GTMedia]()
    
    init(user: GTUser) {
        self.user = user
    }
    
    // TODO: Fetch real values
    func getMediasCount(for user: GTUser) -> Int {
        return Int.random(in: 0...4)
    }
    
    func getFolloersCount(for user: GTUser) -> Int {
        return Int.random(in: 0...123)
    }
    
    func getFollowingCount(for user: GTUser) -> Int {
        return Int.random(in: 0...45)
    }
}
