//
//  FeedTableViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 04/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedTableViewController: UITableViewController {
    
    let posts = DataProviders.shared.postsDataProvider.feed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Feed"
        
        self.tableView.estimatedRowHeight = 200.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell

        cell.configure(with: posts[indexPath.item])
        addActions(cell, posts[indexPath.item])
        
        return cell
    }

    // Добавляет переходы по кнопкам и действия по жестам
    func addActions(_ cell: FeedTableViewCell, _ post: Post) {
        cell.likes.addTarget(self, action: #selector(likesButtonPressed(_:)), for: .touchUpInside)
        cell.likes.titlePage = "Likes"
        cell.likes.postID = post.id
        
        cell.author.addTarget(self, action: #selector(authorButtonPressed(_:)), for: .touchUpInside)
        cell.author.userID = post.author
        
        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        cell.likeButton.postID = post.id
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTappedBigLike(_:)))
        doubleTap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedAvatar(_:)))
        cell.addGestureRecognizer(tap)
    }
    
    @objc func authorButtonPressed(_ sender: DataUIButton) {
        performSegue(withIdentifier: "showAuthorProfileFromFeed", sender: sender)
    }
    
    @objc func likeButtonPressed(_ sender: DataUIButton) {
        if sender.tintColor == UIColor.lightGray {
            sender.tintColor = UIView().tintColor
            DataProviders.shared.postsDataProvider.likePost(with: sender.postID!)
        } else {
            sender.tintColor = UIColor.lightGray
            DataProviders.shared.postsDataProvider.unlikePost(with: sender.postID!)
        }
    }
    
    @objc func doubleTappedBigLike(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? FeedTableViewCell else {
            return
        }
        
        let point = sender.location(in: view)

        if view.photo.frame.contains(point) {
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.values = [0, 1, 1, 0, 0]
            animation.keyTimes = [0, 0.1, 0.3, 0.6, 1]
            animation.duration = 1.0
            let linear = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            let easeOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.timingFunctions = [linear, linear, easeOut, linear]
            
            view.bigLikeImage.layer.add(animation, forKey: "opacity")
            
            // Если лайк уже стоит, то лайк не убирается (так сделано в Инстаграме, если я не ошибаюсь, поэтому так же сделал)
            if view.likeButton.tintColor == UIColor.lightGray {
                likeButtonPressed(view.likeButton)
            }
        }
    }
    
    @objc func tappedAvatar(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? FeedTableViewCell else {
            return
        }
        
        let point = sender.location(in: view)
        
        if view.avatarImage.frame.contains(point) {
            performSegue(withIdentifier: "showAuthorProfileFromFeed", sender: view.author)
        }
    }
    
    @objc func likesButtonPressed(_ sender: DataUIButton) {
        performSegue(withIdentifier: "showLikes", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dataButton = sender as? DataUIButton else {
            return
        }
        
        if let destination = segue.destination as? UsersListTableViewController {
            destination.title = dataButton.titlePage
            destination.users = DataProviders.shared.postsDataProvider.usersLikedPost(with: dataButton.postID!)
        }
        
        if let destination = segue.destination as? ProfileCollectionViewController {
            destination.currentUser = DataProviders.shared.usersDataProvider.user(with: dataButton.userID!)
        }
    }

}
