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
    @IBOutlet weak var buttonSignIn: UIButton!
    
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
        let (token, serverResponse) = ServerQuery.signIn(login: loginField.text!, password: passwordField.text!)
        
        guard token != nil else {
            let alert = Alert.getAlert(error: serverResponse!)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        performSegue(withIdentifier: "showLogIn", sender: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if loginField.text != "" && passwordField.text != "" {
            buttonSignIn.isEnabled = true
            buttonSignIn.alpha = 1
        } else {
            buttonSignIn.alpha = 0.3
            buttonSignIn.isEnabled = false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if loginField.text != "" && passwordField.text != "" {
            signInPressed(self)
        } else {
            print("enter login and password")
        }
        
        return true
    }
    
}
