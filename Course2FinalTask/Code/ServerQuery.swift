//
//  ServerQuery.swift
//  Course2FinalTask
//
//  Created by Vladislav on 08/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

/**
 Класс отвечает за запросы к серверу.
 Названия запросов соответствуют методам класса.
 */

class ServerQuery {
    
    /// Server's URL
    private static let host = "http://localhost:8080"
    private static var token: String? = nil
    /// httpResponse.statusCode from server
    private static var serverResponse: Int? = nil
    
    /**
     - Returns: The function returns tuple (auth token, httpResponse.statusCode). If statusCode != 200 or login/password are invalid, auth token is nil.
     */
    static func signIn(login: String, password: String) -> (String?, Int?) {
        serverResponse = nil
        
        guard let url = URL(string: host + "/signin/") else {
            print("url is empty")
            return (nil, nil)
        }
        
        let encoder = JSONEncoder()
        let account = Account(login: login, password: password)
        let accountData = try? encoder.encode(account)
        
        
        let defaultHeaders = [
            "Content-Type" : "application/json"
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = accountData
        
        let taskGroup = DispatchGroup()
        taskGroup.enter()
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                self.serverResponse = httpResponse.statusCode
                
                if httpResponse.statusCode != 200 {
                    print("error, HTTP status code: \(httpResponse.statusCode)")
                    taskGroup.leave()
                    return
                }
            }
            
            guard let data = data else {
                print("no data received")
                taskGroup.leave()
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Достаём токен
                guard let token = json!["token"] as? String else {
                    print("token is not found")
                    taskGroup.leave()
                    return
                }
                
                self.token = token
                taskGroup.leave()
            }
        }
        dataTask.resume()
        taskGroup.wait()
        
        return (token, serverResponse)
    }
    
    /**
     - Returns: status code of server's response (status code 200 means that user signed out). The function returning nil means token was nil.
     */
    static func signOut() -> (Int?) {
        serverResponse = nil
        
        guard let token = self.token else {
            print("user did not sign in")
            return nil
        }
        
        guard let url = URL(string: host + "/signout/") else {
            print("url is empty")
            return nil
        }
        
        
        let defaultHeaders = [
            "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        
        let taskGroup = DispatchGroup()
        taskGroup.enter()
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                self.serverResponse = httpResponse.statusCode
                
                if httpResponse.statusCode != 200 {
                    print("error, HTTP status code: \(httpResponse.statusCode)")
                    taskGroup.leave()
                    return
                } else {
                    self.token = nil
                    taskGroup.leave()
                }
            }
        }
        dataTask.resume()
        taskGroup.wait()
        
        return self.serverResponse
    }
    
    /**
     - Returns: true if token is valid.
     */
    static func checktoken() -> Bool {
        self.serverResponse = nil

        guard let token = self.token else {
            print("user did not sign in")
            return false
        }

        guard let url = URL(string: host + "/checkToken/") else {
            print("url is empty")
            return false
        }


        let defaultHeaders = [
            "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders

        let taskGroup = DispatchGroup()
        taskGroup.enter()
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, error in

            if let error = error {
                print(error.localizedDescription)
            }

            if let httpResponse = response as? HTTPURLResponse {
                self.serverResponse = httpResponse.statusCode
                
                if httpResponse.statusCode != 200 {
                    print("error, HTTP status code: \(httpResponse.statusCode)")
                    taskGroup.leave()
                    return
                } else {
                    taskGroup.leave()
                }
            }
        }
        dataTask.resume()
        taskGroup.wait()
        
        if serverResponse == 200 {
            return true
        } else {
            return false
        }
    }
    
}
