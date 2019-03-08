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
        guard let url = URL(string: hostURL + "/signin/") else {
            print("url is empty")
            return
        }
        
        let encoder = JSONEncoder()
        let account = Account(login: defaultLogin, password: defaultPassword)
        let accountData = try? encoder.encode(account)
        
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = accountData
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("error, HTTP status code: \(httpResponse.statusCode)")
                    return
                }
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Достаём токен
                guard let token = json!["token"] as? String else {
                        print("token is not found")
                        return
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showLogIn", sender: self)
                }
            }
        }
        
        dataTask.resume()
        
    }
    
}
