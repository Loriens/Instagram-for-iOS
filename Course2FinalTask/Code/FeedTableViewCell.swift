//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Vladislav on 04/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var author: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likes: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var descriptionOfPost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
