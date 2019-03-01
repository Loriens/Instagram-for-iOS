//
//  DescriptionPostViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 27/02/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class DescriptionPostViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionField: UITextField!
    var tempImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = tempImage {
            imageView.image = image
        }
        
        let nextButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(barItemSharePressed(_:)))
        self.navigationItem.rightBarButtonItem = nextButton
    }

}

// Add actions

extension DescriptionPostViewController {
    
    @objc func barItemSharePressed(_ sender: Any?) {
        let shareGroup = DispatchGroup()
        
        shareGroup.enter()
        
        DataProviders.shared.postsDataProvider.newPost(with: imageView.image!, description: descriptionField.text ?? "", queue: DispatchQueue.global(qos: .userInitiated), handler: {(post) in
            if post != nil {
                shareGroup.leave()
            } else {
                print("Post was not shared")
                fatalError()
            }
        })
        
        shareGroup.wait()
        
        performSegue(withIdentifier: "unwindToNewPostVC", sender: self)
    }
    
}