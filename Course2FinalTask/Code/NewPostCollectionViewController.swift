//
//  NewPostCollectionViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 24/02/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

private let reuseIdentifier = "PhotoCell"

class NewPostCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {
    
    let photoProvider = DataProviders.shared.photoProvider
    var photos: [UIImage]?
    var previewPhotoForSegue: [UIImage]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photos = photoProvider.photos()
        previewPhotoForSegue = photoProvider.thumbnailPhotos()

        // Register cell classes
        self.collectionView!.register(NewPostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.tabBarController?.delegate = self

        // Do any additional setup after loading the view.
    }
    
    //  Функция вызывается после публикации фото
    @IBAction func unwintToNewPostVC(segue: UIStoryboardSegue) {
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
        guard let photos = photos else {
            return 0
        }
        
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewPostCollectionViewCell
    
        let imageView = UIImageView(frame: cell.frame)
        if let photo = photos?[indexPath.item] {
            imageView.image = photo
            cell.backgroundView = imageView
            cell.item = indexPath.item
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedImage(_:)))
            cell.addGestureRecognizer(tap)
        }
    
        return cell
    }

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

}

// Add actions

extension NewPostCollectionViewController {
    
    @objc func tappedImage(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? NewPostCollectionViewCell else {
            return
        }
        
        self.performSegue(withIdentifier: "showFilters", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? FilterViewController {
            if let cell = sender as? NewPostCollectionViewCell {
                destination.previewImage = previewPhotoForSegue?[cell.item!]
                
                if let imageView = cell.backgroundView as? UIImageView {
                    destination.tempImage = imageView.image
                }
            }
        }
    }
    
}
