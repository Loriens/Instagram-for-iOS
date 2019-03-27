//
//  User.swift
//  Course2FinalTask
//
//  Created by Vladislav on 09/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    var id: String
    var username: String
    var fullName: String
    var avatar: String
    var currentUserFollowsThisUser: Bool
    var currentUserIsFollowedByThisUser: Bool
    var followsCount: Int
    var followedByCount: Int
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
