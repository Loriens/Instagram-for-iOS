//
//  AlertController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 07/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class Alert {
    
    static func getAlert(error: Int, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        var message: String
        
        switch error {
        case 0:
            message = "Server is not working"
        case 404:
            message = "Not found"
        case 400:
            message = "Bad request"
        case 401:
            message = "Unathorized"
        case 406:
            message = "Not acceptable"
        case 422:
            message = "Unprocessable"
        default:
            message = "Transfer error"
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        return alert
    }

}
