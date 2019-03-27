//
//  UsersListTableViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 05/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class UsersListTableViewController: UITableViewController {
    
    var users: [User]?
    var indicator: CustomActivityIndicator?

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
        
        cell.textLabel?.text = users![indexPath.item].username
        if let url = URL(string: users![indexPath.item].avatar) {
            cell.imageView?.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, URL) in
                cell.setNeedsLayout()
            })
        }
        
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
        sender.userID = users[indexPath.item].id
        
        Spinner.start()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showUserProfileFromUsersList", sender: sender)
            Spinner.stop()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dataButton = sender as? DataUIButton else {
            return
        }
        
        if let destination = segue.destination as? ProfileCollectionViewController {
            (destination.currentUser, _) = ServerQuery.user(id: dataButton.userID!)
        }
    }

}
