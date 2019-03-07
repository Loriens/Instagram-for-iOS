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
    
    @IBOutlet weak var likeButton: DataUIButton!
    @IBOutlet weak var author: DataUIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionOfPost: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likes: DataUIButton!
    @IBOutlet weak var bigLikeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // Собирает ячейку FeedTableViewCell в соответствия с данными из публикации
    func configure(with post: Post) {
        avatarImage.image = post.authorAvatar
        author.setTitle(post.authorUsername, for: .normal)
        photo.image = post.image
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
        
        var usersLikedPost = [User.Identifier]()
        var currentUserId = User.Identifier(rawValue: "")
        DataProviders.shared.postsDataProvider.usersLikedPost(with: post.id, queue: DispatchQueue.global(qos: .background), handler: {
            users in
            
            if users != nil {
                for user in users! {
                    usersLikedPost.append(user.id)
                }
            }
        })
        DataProviders.shared.usersDataProvider.currentUser(queue: DispatchQueue.global(qos: .background), handler: {
            user in
            currentUserId = user!.id
        })
        
        if usersLikedPost.contains(currentUserId) {
            likeButton.tintColor = UIView().tintColor
        } else {
            likeButton.tintColor = UIColor.lightGray
        }
        
        // Не нашёл размеров сердца bigLike, на глаз прикинул его размер
        likeButton.frame.size.width = self.frame.width / 4
    }
    
}
