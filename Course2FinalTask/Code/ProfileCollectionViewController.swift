//
//  ProfileCollectionViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 06/12/2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "CollectionCell"
private let headerReuseIdentifier = "ProfileHeader"

class ProfileCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // Пользователь просматриваемой страницы
    var currentUser: User?
    // true, если страница владельца аккаунта
    var isBaseProfile = false
    var indicator: CustomActivityIndicator?
    private var posts: [Post] = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Определяем страницу пользователя, которую нужно отобразить
        if let user = currentUser {
            self.navigationItem.title = user.username
        } else {
            isBaseProfile = true
            
            self.currentUser = ServerQuery.currentUser()
            self.navigationItem.title = currentUser?.username
            
            let logOutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(barItemLogOutPressed(_:)))
            self.navigationItem.rightBarButtonItem = logOutButton
        }
        
        // Загружаем публикации пользователя
        if let posts = ServerQuery.userPosts(id: currentUser!.id) {
            let sortedPosts = posts.sorted(by: { firstPost, secondPost in
                return firstPost.createdTime > secondPost.createdTime
            })
            self.posts = sortedPosts
        } else {
            self.present(AlertController.getAlert(), animated: true, completion: nil)
            self.posts = [Post]()
        }

        // Register cell classes
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.register(UINib.init(nibName: "ProfileHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let posts = ServerQuery.userPosts(id: currentUser!.id) {
            if posts.count > self.posts.count {
                /// Преобразует строку в тип Date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatter.locale = Locale(identifier: "en_US")
                
                let sortedPosts = posts.sorted(by: { firstPost, secondPost in
                    return dateFormatter.date(from: firstPost.createdTime)! > dateFormatter.date(from: secondPost.createdTime)!
                })
                self.posts = sortedPosts
                self.collectionView?.reloadData()
            }
        } else {
            print("Posts are not found")
        }
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
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let imageView = UIImageView(frame: cell.frame)
        imageView.kf.setImage(with: URL(string: posts[indexPath.item].image))
        cell.backgroundView = imageView
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ProfileHeaderCollectionReusableView

        var user: User
        if let currUser = currentUser {
            user = currUser
        } else {
            fatalError()
        }

        headerView.avatar.kf.setImage(with: URL(string: currentUser!.avatar))
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
    
    /// Выполняет выход из профиля
    @objc func barItemLogOutPressed(_ sender: Any?) {
        if ServerQuery.signOut() == 200 {
            performSegue(withIdentifier: "unwindtoLoginVC", sender: self)
        } else {
            print("can't sign out")
        }
    }
    
    /// Добавляет переходы по кнопкам и действия по жестам
    func addActions(_ user: User, _ headerView: ProfileHeaderCollectionReusableView) {
        headerView.followers.addTarget(self, action: #selector(followersButtonPressed(_:)), for: .touchUpInside)
        headerView.following.addTarget(self, action: #selector(followingButtonPressed(_:)), for: .touchUpInside)
        headerView.follow.addTarget(self, action: #selector(followButtonPressed(_:)), for: .touchUpInside)
        
        headerView.followers.titlePage = "Followers"
        headerView.following.titlePage = "Following"
        
        headerView.followers.userID = currentUser!.id
        headerView.following.userID = currentUser!.id
    }
    
    @objc func followersButtonPressed(_ sender: DataUIButton) {
        Spinner.start()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showUsersListFromProfile", sender: sender)
            Spinner.stop()
        }
    }
    
    @objc func followingButtonPressed(_ sender: DataUIButton) {
        Spinner.start()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showUsersListFromProfile", sender: sender)
            Spinner.stop()
        }
    }
    
    @objc func followButtonPressed(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text,
            let header = self.collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? ProfileHeaderCollectionReusableView else {
            print("Text or header are not found")
            return
        }

        guard let arrayOfFollowers = header.followers.title(for: .normal)?.components(separatedBy: CharacterSet.decimalDigits.inverted) else {
            return
        }

        let followersCount = Int(arrayOfFollowers.last!)!

        if text == "Follow" {
            ServerQuery.follow(id: currentUser!.id)
            
            UIView.performWithoutAnimation {
                header.followers.setTitle("Followers: \(followersCount + 1)", for: .normal)
                header.followers.layoutIfNeeded()
            }

            sender.setTitle("Unfollow", for: .normal)
            sender.sizeToFit()
        } else {
            ServerQuery.unfollow(id: currentUser!.id)
            
            UIView.performWithoutAnimation {
                header.followers.setTitle("Followers: \(followersCount - 1)", for: .normal)
                header.followers.layoutIfNeeded()
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
            var users: [User]?
            destination.title = dataButton.titlePage
            
            if dataButton.titlePage!.contains("Following") {
                users = ServerQuery.following(id: currentUser!.id)
            } else {
                users = ServerQuery.followers(id: currentUser!.id)
            }
            
            if let unwrapUsers = users {
                destination.users = unwrapUsers
            } else {
                destination.users = [User]()
            }
        }
    }
}
