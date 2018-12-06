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
    }
    
    @objc func likesButtonPressed(_ sender: DataUIButton) {
        let UsersListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UsersListTableViewController") as! UsersListTableViewController
        view.addSubview(UsersListVC.view)
        UsersListVC.title = sender.titlePage
        UsersListVC.users = DataProviders.shared.postsDataProvider.usersLikedPost(with: sender.postID!)

        self.navigationController?.pushViewController(UsersListVC, animated: true)
    }

}
