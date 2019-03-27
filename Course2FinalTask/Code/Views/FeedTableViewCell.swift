//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Vladislav on 04/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    /// Собирает ячейку FeedTableViewCell в соответствия с данными из публикации
    func configure(with post: Post) {
        avatarImage.kf.setImage(with: URL(string: post.authorAvatar)!)
        author.setTitle(post.authorUsername, for: .normal)
        photo.kf.setImage(with: URL(string: post.image)!)
        descriptionOfPost.text = post.description
        descriptionOfPost.sizeToFit()
        likes.setTitle("Likes: \(post.likedByCount)", for: .normal)
        
        let anotherDateFormatter = DateFormatter()
        anotherDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        anotherDateFormatter.locale = Locale(identifier: "en_US")
        let dateFromString = anotherDateFormatter.date(from: post.createdTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        let date = dateFormatter.string(from: dateFromString!)
        timeLabel.text = date
        
        // Не нашёл размеров сердца bigLike, на глаз прикинул его размер
        likeButton.frame.size.width = self.frame.width / 4
        
        let usersLikedPost = ServerQuery.postLikes(postId: post.id)
        let currentUser = ServerQuery.currentUser()!
        
        guard let usersLikedPostUnwrapped = usersLikedPost else {
            likeButton.tintColor = UIColor.lightGray
            return
        }
        
        for user in usersLikedPostUnwrapped {
            if user == currentUser {
                likeButton.tintColor = UIView().tintColor
                return
            }
        }
        
        likeButton.tintColor = UIColor.lightGray
    }
    
}
