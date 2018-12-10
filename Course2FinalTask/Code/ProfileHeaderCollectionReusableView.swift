//
//  ProfileHeaderCollectionReusableView.swift
//  Course2FinalTask
//
//  Created by Vladislav on 10/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var followers: DataUIButton!
    @IBOutlet weak var following: DataUIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        avatar.layer.cornerRadius = avatar.frame.height / 2.0
        avatar.layer.masksToBounds = true
    }
    
}
