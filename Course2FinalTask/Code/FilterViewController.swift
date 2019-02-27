//
//  FilterViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 25/02/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    var tempImage: UIImage?
    var previewImage: UIImage?
//    var indicator: CustomActivityIndicator?
    private let filterNames = ["CIColorInvert", "CISepiaTone", "CICrystallize", "CIMotionBlur", "CIVibrance"]
    private let filter = ImageFilter()
    private let reuseIdentifier = "FilterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let view = self.tabBarController?.view {
//            indicator = CustomActivityIndicator(view: view)
//        }
        
        if let image = tempImage {
            mainImage.image = image
        }
        
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        filtersCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }

}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FilterCollectionViewCell
        
        cell.filterName.text = filterNames[indexPath.item]
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let ciimage = CIImage(image: self.previewImage!) {
                let resultImage = self.filter.applyFilter(name: self.filterNames[indexPath.item], params: [kCIInputImageKey: ciimage])
                DispatchQueue.main.async {
                    cell.previewImage.image = resultImage
                }
            }

        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedCell(_:)))
        cell.addGestureRecognizer(tap)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120.0, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
}

// Add actions

extension FilterViewController {
    
    @objc func tappedCell(_ sender: UITapGestureRecognizer) {
        
//        indicator?.startAnimating()
        
        guard let view = sender.view as? FilterCollectionViewCell else {
            return
        }
        
        let filterGroup = DispatchGroup()
        
        filterGroup.enter()
        let nameFilter = view.filterName.text!
        var resultImage: UIImage?
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let ciimage = CIImage(image: self.tempImage!) {
                resultImage = self.filter.applyFilter(name: nameFilter, params: [kCIInputImageKey: ciimage])
                filterGroup.leave()
            }
        }
        
        filterGroup.wait()
        DispatchQueue.main.async {
            self.mainImage.image = resultImage
//            self.indicator?.stopAnimating()
        }
    }
    
}
