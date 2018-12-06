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

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if let user = userProvider.user(with: users![indexPath.item]) {
            cell.textLabel?.text = user.username
            cell.imageView?.image = user.avatar
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

}
