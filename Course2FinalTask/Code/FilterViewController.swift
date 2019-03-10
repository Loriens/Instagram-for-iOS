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
    var tempImage: String?
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
            mainImage.image = UIImage(named: tempImage!)
        }
        
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(barItemNextPressed(_:)))
        self.navigationItem.rightBarButtonItem = nextButton
        
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        filtersCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Размещаем фильтры по центру пустого места на экране
        // Размеры фильтра
        let widthFilter = filtersCollectionView.layer.frame.width
        let heightFilter = filtersCollectionView.frame.height
        //Отступы сверху и снизу для таб и нав баров
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        let bottomPadding = window?.safeAreaInsets.bottom
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        // Отступ сверху для filterCollectionView
        let topInset = (self.view.frame.height - mainImage.frame.height - topPadding! - bottomPadding!) / 2 - heightFilter
        
        // Настраиваем constraints
        NSLayoutConstraint.activate([
            filtersCollectionView.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: topInset),
//            filtersCollectionView.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: bottomInset),
            filtersCollectionView.heightAnchor.constraint(equalToConstant: heightFilter),
            filtersCollectionView.widthAnchor.constraint(equalToConstant: widthFilter)
        ])
        
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
            if let ciimage = CIImage(image: UIImage(named: self.tempImage!)!) {
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
        
        // Spinner does not work
        Spinner.start()
        
        guard let view = sender.view as? FilterCollectionViewCell else {
            return
        }
        
        if let image = view.previewImage.image {
            self.mainImage.image = image
            Spinner.stop()
            return
        }
        
        let filterGroup = DispatchGroup()
        
        filterGroup.enter()
        let nameFilter = view.filterName.text!
        var resultImage: UIImage?
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let ciimage = CIImage(image: UIImage(named: self.tempImage!)!) {
                resultImage = self.filter.applyFilter(name: nameFilter, params: [kCIInputImageKey: ciimage])
                filterGroup.leave()
                
                DispatchQueue.main.async {
                    Spinner.stop()
                }
            }
        }
        
        filterGroup.wait()
        
        self.mainImage.image = resultImage
    }
    
    @objc func barItemNextPressed(_ sender: Any?) {
        performSegue(withIdentifier: "showDescription", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DescriptionPostViewController {
            destination.tempImage = mainImage.image
        }
    }
    
}
