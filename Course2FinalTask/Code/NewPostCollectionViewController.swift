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
    
    private var photosCount = 7

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView!.register(NewPostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        tabBarController?.delegate = self

        // Do any additional setup after loading the view.
    }
    
    ///  Функция вызывается после публикации фото
    @IBAction func unwintToNewPostVC(segue: UIStoryboardSegue) {
        Spinner.stop()
        
        tabBarController?.selectedIndex = 0
        
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photosCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewPostCollectionViewCell
    
        let imageView = UIImageView(frame: cell.frame)
        imageView.image = UIImage(named: "new" + String(indexPath.item + 1))
        cell.backgroundView = imageView
        cell.item = indexPath.item + 1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedImage(_:)))
        cell.addGestureRecognizer(tap)
    
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
                destination.tempImage = "new" + String(cell.item!)
            }
        }
    }
    
}
