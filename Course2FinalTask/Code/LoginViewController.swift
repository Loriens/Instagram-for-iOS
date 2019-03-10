//
//  LoginViewController.swift
//  Course2FinalTask
//
//  Created by Vladislav on 08/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private let defaultLogin: String = "user"
    private let defaultPassword: String = "qwerty"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginField.delegate = self
        passwordField.delegate = self
    }
    
    /// Функция вызывается после выхода из профиля
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {
        // do something
        
    }

    @IBAction func signInPressed(_ sender: Any) {
        let (token, _) = ServerQuery.signIn(login: defaultLogin, password: defaultPassword)
        
        guard token != nil else {
            print("token is empty")
            return
        }
        
        performSegue(withIdentifier: "showLogIn", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signInPressed(self)
        return true
    }
    
}
