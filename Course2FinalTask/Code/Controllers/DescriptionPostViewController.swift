//
//  DescriptionPostViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 27/02/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

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
        Spinner.start()
        if descriptionField.text == nil {
            descriptionField.text = ""
        }
        
        let imageData = UIImagePNGRepresentation(tempImage!)!
        
        
        ServerQuery.post(image: imageData.base64EncodedString(), description: descriptionField.text!)
        performSegue(withIdentifier: "unwindToNewPostVC", sender: self)
    }
    
}
