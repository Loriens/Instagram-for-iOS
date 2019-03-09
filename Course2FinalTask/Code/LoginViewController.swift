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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
//        print(ServerQuery.unlike(postId: "27"))
//        print(ServerQuery.unlike(postId: "10000"))
        
        performSegue(withIdentifier: "showLogIn", sender: self)
    }
    
}
