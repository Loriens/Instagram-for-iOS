//
//  DataUIButton.swift
//  Course2FinalTask
//
//  Created by Vladislav on 06/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

@objc class DataUIButton: UIButton {
    var titlePage: String?
    var postID: Post.Identifier?
    var userID: User.Identifier?
}
