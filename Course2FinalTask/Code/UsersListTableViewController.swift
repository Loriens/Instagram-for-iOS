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
    
    var posts: Post?
    var pageTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let receivedText = pageTitle {
            self.title = receivedText
        }

        self.navigationController?.navigationItem.hidesBackButton = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
