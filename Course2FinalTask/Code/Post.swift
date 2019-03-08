//
//  Post.swift
//  Course2FinalTask
//
//  Created by Vladislav on 09/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

struct PostCodable: Codable {
    var id: String
    var authorID: String
    var description: String
    var image: String
    var createdTime: Int
    var currentUserLikesThisPost: Bool
    var likedByCount: Int
    var authorUsername: String
    var authorAvatar: String
}
