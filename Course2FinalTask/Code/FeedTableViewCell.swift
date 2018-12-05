//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Vladislav on 04/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var author: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionOfPost: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likes: UIButton!
    @IBOutlet weak var likeButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(with post: Post) {
        avatarImage.image = post.authorAvatar
        author.setTitle(post.authorUsername, for: .normal)
        photo.image = post.image
        likeButton.tintColor = UIColor.lightGray
        descriptionOfPost.text = post.description
        descriptionOfPost.sizeToFit()
        likes.setTitle("Likes: \(post.likedByCount)", for: .normal)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        let date = dateFormatter.string(from: post.createdTime)
        
        timeLabel.text = date
    }
    
}
