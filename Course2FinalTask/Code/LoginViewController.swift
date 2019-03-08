//
//  LoginViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 08/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private let defaultLogin: String = "user"
    private let defaultPassword: String = "qwerty"
    private let hostURL = "http://localhost:8080"
    private let defaultHeaders = [
        "Content-Type" : "application/json"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInPressed(_ sender: Any) {
        let (token, _) = ServerQuery.signIn(login: defaultLogin, password: defaultPassword)
        
        guard token != nil else {
            print("token is empty")
            return
        }
        
        performSegue(withIdentifier: "showLogIn", sender: self)
    }
    
}
