//
//  ProfileCollectionViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 06/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

private let reuseIdentifier = "CollectionCell"
private let headerReuseIdentifier = "ProfileHeader"

class ProfileCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let dataProvider = DataProviders.shared.postsDataProvider
    let userProvider = DataProviders.shared.usersDataProvider
    // Пользователь просматриваемой страницы
    var currentUser: User?
    // true, если страница владельца аккаунта
    var isBaseProfile = false
    var indicator: CustomActivityIndicator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.tabBarController?.view {
            indicator = CustomActivityIndicator(view: view)
        }

        if let user = currentUser {
            self.navigationItem.title = user.username
        } else {
            isBaseProfile = true
            
            let currentUserGroup = DispatchGroup()
            currentUserGroup.enter()
            userProvider.currentUser(queue: DispatchQueue.global(qos: .userInteractive), handler: {
                user in
                
                self.currentUser = user
                
                currentUserGroup.leave()
            })
            currentUserGroup.wait()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UINib.init(nibName: "ProfileHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        var count = 0
        
        if let user = currentUser {
            let findPostsGroup = DispatchGroup()
            
            findPostsGroup.enter()
            
            dataProvider.findPosts(by: user.id, queue: DispatchQueue.global(qos: .userInteractive), handler: {
                posts in
                count = posts!.count
                findPostsGroup.leave()
            })
            
            findPostsGroup.wait()
        }
        
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let user = currentUser {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            
            let imageView = UIImageView(frame: cell.frame)
            let findPostsGroup = DispatchGroup()
            
            findPostsGroup.enter()
            
            dataProvider.findPosts(by: user.id, queue: DispatchQueue.global(qos: .userInteractive), handler: {
                posts in
                DispatchQueue.main.async {
                    imageView.image = posts![indexPath.item].image
                    cell.backgroundView = imageView
                }
                findPostsGroup.leave()
            })
            
            findPostsGroup.wait()
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ProfileHeaderCollectionReusableView

        var user: User
        if let currUser = currentUser {
            user = currUser
        } else {
            fatalError()
        }

        headerView.avatar.image = user.avatar
        headerView.fullName.text = user.fullName
        headerView.followers.setTitle("Followers: \(user.followedByCount)", for: .normal)
        headerView.following.setTitle("Following: \(user.followsCount)", for: .normal)
        addActions(user, headerView)
        
        if isBaseProfile {
            headerView.follow.isHidden = true
        }

        return headerView
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView!.frame.width / 3, height: self.collectionView!.frame.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView!.frame.width, height: 86.0)
    }

}


// Add actions for buttons

extension ProfileCollectionViewController {
    
    // Добавляет переходы по кнопкам и действия по жестам
    func addActions(_ user: User, _ headerView: ProfileHeaderCollectionReusableView) {
        headerView.followers.addTarget(self, action: #selector(followersButtonPressed(_:)), for: .touchUpInside)
        headerView.following.addTarget(self, action: #selector(followingButtonPressed(_:)), for: .touchUpInside)
        headerView.follow.addTarget(self, action: #selector(followButtonPressed(_:)), for: .touchUpInside)
        
        headerView.followers.titlePage = "Followers"
        headerView.following.titlePage = "Following"
        
        headerView.followers.userID = user.id
        headerView.following.userID = user.id
    }
    
    @objc func followersButtonPressed(_ sender: DataUIButton) {
        indicator?.startAnimating()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showUsersListFromProfile", sender: sender)
            self.indicator?.stopAnimating()
        }
    }
    
    @objc func followingButtonPressed(_ sender: DataUIButton) {
        indicator?.startAnimating()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showUsersListFromProfile", sender: sender)
            self.indicator?.stopAnimating()
        }
    }
    
    @objc func followButtonPressed(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else {
            print("Text is not found")
            return
        }
        
        if text == "Follow" {
            userProvider.follow(currentUser!.id, queue: DispatchQueue.global(qos: .userInteractive)) { _ in
            }
            
            sender.setTitle("Unfollow", for: .normal)
            sender.sizeToFit()
        } else {
            userProvider.unfollow(currentUser!.id, queue: DispatchQueue.global(qos: .userInteractive)) { _ in
            }
            
            sender.setTitle("Follow", for: .normal)
            sender.sizeToFit()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dataButton = sender as? DataUIButton else {
            return
        }
        
        if let destination = segue.destination as? UsersListTableViewController {
            var users = [User]()
            
            destination.title = dataButton.titlePage
            
            let prepareGroup = DispatchGroup()
            
            prepareGroup.enter()
            
            if dataButton.titlePage!.contains("Following") {
                userProvider.usersFollowedByUser(with: dataButton.userID!, queue: DispatchQueue.global(qos: .userInteractive), handler: {
                    usersFound in
                    
                    for user in usersFound! {
                        users.append(user)
                    }
                    
                    prepareGroup.leave()
                })
            } else {
                userProvider.usersFollowingUser(with: dataButton.userID!, queue: DispatchQueue.global(qos: .userInteractive), handler: {
                    usersFound in
                    
                    for user in usersFound! {
                        users.append(user)
                    }
                    
                    prepareGroup.leave()
                })
            }
            
            prepareGroup.wait()
            
            destination.users = [User.Identifier]()
            
            for user in users {
                destination.users?.append(user.id)
            }
        }
    }
}
