//
//  FeedTableViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 04/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    var posts: [Post]?
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedGroup = DispatchGroup()
        feedGroup.enter()
        // В данном месте целесообразно не ставить индикатор активности, потому что это окно открывается самым первым при открытии приложения
        self.posts = ServerQuery.feed()
        
        title = "Feed"
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let newPosts = ServerQuery.feed()
        if newPosts.count > self.posts!.count {
            self.posts = newPosts
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let posts = posts else {
//            fatalError()
            return 0
        }
        
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let posts = posts else {
//            fatalError()
            return UITableViewCell()
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell

        cell.configure(with: posts[indexPath.item])
        addActions(cell, posts[indexPath.item], indexPath)
        
        return cell
    }

    // Добавляет переходы по кнопкам и действия по жестам
    func addActions(_ cell: FeedTableViewCell, _ post: Post, _ index: IndexPath) {
        cell.likes.addTarget(self, action: #selector(likesButtonPressed(_:)), for: .touchUpInside)
        cell.likes.titlePage = "Likes"
        cell.likes.postID = post.id
        
        cell.author.addTarget(self, action: #selector(authorButtonPressed(_:)), for: .touchUpInside)
        cell.author.userID = post.author
        
        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        cell.likeButton.postID = post.id
        cell.likeButton.likes = cell.likes
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTappedBigLike(_:)))
        doubleTap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedAvatar(_:)))
        cell.addGestureRecognizer(tap)
    }
    
    @objc func authorButtonPressed(_ sender: DataUIButton) {
        Spinner.start()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showAuthorProfileFromFeed", sender: sender)
            Spinner.stop()
        }
    }
    
    @objc func likeButtonPressed(_ sender: DataUIButton) {
        if sender.tintColor == UIColor.lightGray {
            sender.tintColor = UIView().tintColor
            
            guard let likes = sender.likes, let post = sender.postID, let arrayOfLikesTitle = likes.title(for: .normal)?.components(separatedBy: CharacterSet.decimalDigits.inverted) else {
                return
            }
            
            let countOfLikes = Int(arrayOfLikesTitle.last!)! + 1
            UIView.performWithoutAnimation {
                likes.setTitle("Likes: \(countOfLikes)", for: .normal)
                likes.layoutIfNeeded()
            }
            ServerQuery.like(postId: post)
        } else {
            sender.tintColor = UIColor.lightGray
            
            
            guard let likes = sender.likes, let post = sender.postID, let arrayOfLikesTitle = likes.title(for: .normal)?.components(separatedBy: CharacterSet.decimalDigits.inverted) else {
                return
            }
            
            let countOfLikes = Int(arrayOfLikesTitle.last!)! - 1
            UIView.performWithoutAnimation {
                likes.setTitle("Likes: \(countOfLikes)", for: .normal)
                likes.layoutIfNeeded()
            }
            ServerQuery.unlike(postId: post)
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
            Spinner.start()
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showAuthorProfileFromFeed", sender: view.author)
                Spinner.stop()
            }
        }
    }
    
    @objc func likesButtonPressed(_ sender: DataUIButton) {
        Spinner.start()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showLikes", sender: sender)
            Spinner.stop()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dataButton = sender as? DataUIButton else {
            return
        }
        
        let prepareGroup = DispatchGroup()
        
        prepareGroup.enter()
        
        if let destination = segue.destination as? UsersListTableViewController {
            destination.title = dataButton.titlePage
            destination.users = ServerQuery.postLikes(postId: dataButton.postID!)
            prepareGroup.leave()
        }
        
        if let destination = segue.destination as? ProfileCollectionViewController {
            (destination.currentUser, _) = ServerQuery.user(id: dataButton.userID!)
            prepareGroup.leave()
        }
        
        prepareGroup.wait()

    }

}
