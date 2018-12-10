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

    func addActions(_ cell: FeedTableViewCell, _ post: Post) {
        cell.likes.addTarget(self, action: #selector(likesButtonPressed(_:)), for: .touchUpInside)
        cell.likes.titlePage = "Likes"
        cell.likes.postID = post.id
        
        cell.author.addTarget(self, action: #selector(authorButtonPressed(_:)), for: .touchUpInside)
        cell.author.userID = post.author
    }
    
    @objc func authorButtonPressed(_ sender: DataUIButton) {
        performSegue(withIdentifier: "showAuthorProfileFromFeed", sender: sender)
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
