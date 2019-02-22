//
//  UsersListTableViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 05/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class UsersListTableViewController: UITableViewController {
    
    var users: [User.Identifier]?
    var userProvider = DataProviders.shared.usersDataProvider
    var indicator: CustomActivityIndicator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.tabBarController?.view {
            indicator = CustomActivityIndicator(view: view)
        }

        self.navigationController?.navigationItem.hidesBackButton = false
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = users?.count else  {
            return 0
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserCell")!
        
        let userGroup = DispatchGroup()
        
        userGroup.enter()
        
        userProvider.user(with: users![indexPath.item], queue: DispatchQueue.global(qos: .userInteractive), handler: {
            user in
            DispatchQueue.main.async {
                cell.textLabel?.text = user!.username
                cell.imageView?.image = user!.avatar
            }
            
            userGroup.leave()
        })
        
        userGroup.wait()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sender = DataUIButton()
        
        guard let users = users else {
            return
        }
        sender.userID = users[indexPath.item]
        
        indicator?.startAnimating()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showUserProfileFromUsersList", sender: sender)
            self.indicator?.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dataButton = sender as? DataUIButton else {
            return
        }
        
        if let destination = segue.destination as? ProfileCollectionViewController {
            let userGroup = DispatchGroup()
            
            userGroup.enter()
            
            DataProviders.shared.usersDataProvider.user(with: dataButton.userID!, queue: DispatchQueue.global(qos: .userInteractive), handler: {
                user in
                destination.currentUser = user
                userGroup.leave()
            })
            
            userGroup.wait()
        }
    }

}
