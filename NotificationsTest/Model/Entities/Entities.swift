//
//  Entities.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation

struct GTNotification {
    enum GTType {
        case liked(user: GTUser, media: GTMedia)
        case following(GTUser)
        case checkOut(GTCheckOut)
        case recommendation(GTRecommendation)
    }
    
    let id: String
    let type: GTType
    var isUnread = true
    var updatedAt: Date
}

enum GTRecommendation {
    case media(GTMedia)
    case user(GTUser)
}

enum GTCheckOut {
    case challenge(GTChallenge, name: String?)
    case user(GTUser)
}

struct GTMedia {
    enum GTType: String, Codable {
        case video
        case photo
    }
    
    let type: GTType
    let url: String
}

struct GTUser {
    let id: String
    let name: String?
    let avatar: GTMedia?
}

struct GTChallenge {
    enum GTType: String, Codable {
        case new
    }
    
    let type: GTType
    let media: GTMedia?
}


// Codable to save to temporary local storage
extension GTUser: Codable {}
extension GTMedia: Codable {}
extension GTChallenge: Codable {}
extension GTNotification: Codable {}

extension GTCheckOut: Codable {
    private enum CodingKeys: String, CodingKey {
        case base, challengeParams, user
    }
    
    private enum Base: String, Codable {
        case challenge, user
    }
    
    private struct ChallengeParams: Codable {
        let challenge: GTChallenge
        let name: String?
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        
        switch base {
        case .challenge:
            let challengeParams = try container.decode(ChallengeParams.self, forKey: .challengeParams)
            self = .challenge(challengeParams.challenge, name: challengeParams.name)
        case .user:
            let user = try container.decode(GTUser.self, forKey: .user)
            self = .user(user)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .challenge(let challenge, let name):
            try container.encode(Base.challenge, forKey: .base)
            try container.encode(ChallengeParams(challenge: challenge, name: name), forKey: .challengeParams)
        case .user(let user):
            try container.encode(Base.user, forKey: .base)
            try container.encode(user, forKey: .user)
        }
    }
}

extension GTRecommendation: Codable {
    private enum CodingKeys: String, CodingKey {
        case base, media, user
    }
    
    private enum Base: String, Codable {
        case media, user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        switch base {
        case .media:
            let media = try container.decode(GTMedia.self, forKey: .media)
            self = .media(media)
        case .user:
            let user = try container.decode(GTUser.self, forKey: .user)
            self = .user(user)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .media(let media):
            try container.encode(Base.media, forKey: .base)
            try container.encode(media, forKey: .media)
        case .user(let user):
            try container.encode(Base.user, forKey: .base)
            try container.encode(user, forKey: .user)
        }
    }
}

extension GTNotification.GTType: Codable {
    private enum CodingKeys: String, CodingKey {
        case base, likedParams, user, checkOut, recommendation
    }
    
    private enum Base: String, Codable {
        case liked, following, checkOut, recommendation
    }
    
    private struct LikedParams: Codable {
        let user: GTUser
        let media: GTMedia
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        
        switch base {
        case .liked:
            let likeParams = try container.decode(LikedParams.self, forKey: .likedParams)
            self = .liked(user: likeParams.user, media: likeParams.media)
        case .following:
            let user = try container.decode(GTUser.self, forKey: .user)
            self = .following(user)
        case .checkOut:
            let checkOut = try container.decode(GTCheckOut.self, forKey: .checkOut)
            self = .checkOut(checkOut)
        case .recommendation:
            let recommendation = try container.decode(GTRecommendation.self, forKey: .recommendation)
            self = .recommendation(recommendation)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .liked(let user, let media):
            try container.encode(Base.liked, forKey: .base)
            try container.encode(LikedParams(user: user, media: media), forKey: .likedParams)
        case .following(let user):
            try container.encode(Base.following, forKey: .base)
            try container.encode(user, forKey: .user)
        case .checkOut(let checkOut):
            try container.encode(Base.checkOut, forKey: .base)
            try container.encode(checkOut, forKey: .checkOut)
        case .recommendation(let recommendation):
            try container.encode(Base.recommendation, forKey: .base)
            try container.encode(recommendation, forKey: .recommendation)
        }
    }
}
