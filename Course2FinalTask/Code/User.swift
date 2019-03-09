//
//  User.swift
//  Course2FinalTask
//
//  Created by Vladislav on 09/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

struct UserCodable: Codable {
    var id: String
    var username: String
    var fullName: String
    var avatar: String
    var currentUserFollowsThisUser: Bool
    var currentUserIsFollowedByThisUser: Bool
    var followsCount: Int
    var followedByCount: Int
}
