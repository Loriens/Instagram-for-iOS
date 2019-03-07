//
//  AlertController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 07/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class AlertController {
    
    static func getAlert(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "Unknown error", message: "Please, try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        
        return alert
    }

}
