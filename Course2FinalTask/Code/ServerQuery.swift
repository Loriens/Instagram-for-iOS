//
//  ServerQuery.swift
//  Course2FinalTask
//
//  Created by Vladislav on 08/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

/**
 Class provides server requests on the host "http://localhost:8080".
 Enter "./Run" in the terminal to start the server.
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
            print("user did not sign in, token is nil")
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
    static func checkToken() -> Bool {
        self.serverResponse = nil

        guard let token = self.token else {
            print("user did not sign in, token is nil")
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
    
    static func currentUser() -> UserCodable? {
        self.serverResponse = nil
        var currentUser: UserCodable?
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return currentUser
        }
        
        guard let url = URL(string: host + "/users/me/") else {
            print("url is empty")
            return currentUser
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
                }
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            let decoder = JSONDecoder()
            currentUser = try? decoder.decode(UserCodable.self, from: data)
            taskGroup.leave()
        }
        dataTask.resume()
        taskGroup.wait()
        
        return currentUser
    }
    
    /**
     - Returns: tuple (User, httpResponse.statusCode).
     */
    static func user(id: String) -> (UserCodable?, Int?) {
        self.serverResponse = nil
        var user: UserCodable?
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return (nil, serverResponse)
        }
        
        guard let url = URL(string: host + "/users/" + id) else {
            print("url is empty")
            return (nil, serverResponse)
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
                }
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            let decoder = JSONDecoder()
            user = try? decoder.decode(UserCodable.self, from: data)
            taskGroup.leave()
        }
        dataTask.resume()
        taskGroup.wait()
        
        return (user, serverResponse)
    }
    
    /**
     - Returns: tuple (success, httpResponse.statusCode). If success is true the current user successfully follows user
     */
    static func follow(id: String) -> (Bool, Int?) {
        serverResponse = nil
        var success = false
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return (success, serverResponse)
        }
        
        guard let url = URL(string: host + "/users/follow") else {
            print("url is empty")
            return (success, serverResponse)
        }
        
        let jsonId = [ "userID" : id]
        let idData = try? JSONSerialization.data(withJSONObject: jsonId, options: [])
        
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = idData
        
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
                
                
                taskGroup.leave()

            }
            
            success = true
        }
        dataTask.resume()
        taskGroup.wait()
        
        return (success, serverResponse)
    }
    
    /**
     - Returns: tuple (success, httpResponse.statusCode). If success is true the current user successfully unfollows user
     */
    static func unfollow(id: String) -> (Bool, Int?) {
        serverResponse = nil
        var success = false
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return (success, serverResponse)
        }
        
        guard let url = URL(string: host + "/users/unfollow") else {
            print("url is empty")
            return (success, serverResponse)
        }
        
        let jsonId = [ "userID" : id]
        let idData = try? JSONSerialization.data(withJSONObject: jsonId, options: [])
        
        
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = idData
        
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
                
                
                taskGroup.leave()
                
            }
            
            success = true
        }
        dataTask.resume()
        taskGroup.wait()
        
        return (success, serverResponse)
    }
    
    /**
     - Returns: If returns nil, the user was not found.
     */
    static func followers(id: String) -> [UserCodable]? {
        var users: [UserCodable]? = [UserCodable]()

        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return users
        }

        guard let url = URL(string: host + "/users/" + id + "/followers") else {
            print("url is empty")
            return users
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
                    users = nil
                    taskGroup.leave()
                    return
                }
            }

            guard let data = data else {
                print("no data received")
                return
            }

            let decoder = JSONDecoder()
            users = try? decoder.decode([UserCodable].self, from: data)
            taskGroup.leave()
        }
        dataTask.resume()
        taskGroup.wait()

        return users
    }
    
    /**
     - Returns: If returns nil, the user was not found.
     */
    static func following(id: String) -> [UserCodable]? {
        var users: [UserCodable]? = [UserCodable]()
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return users
        }
        
        guard let url = URL(string: host + "/users/" + id + "/followers") else {
            print("url is empty")
            return users
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
                    users = nil
                    taskGroup.leave()
                    return
                }
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            let decoder = JSONDecoder()
            users = try? decoder.decode([UserCodable].self, from: data)
            taskGroup.leave()
        }
        dataTask.resume()
        taskGroup.wait()
        
        return users
    }
    
    /**
     - Returns: If returns nil, the user was not found.
     */
    static func userPosts(id: String) -> [PostCodable]? {
        var posts: [PostCodable]? = [PostCodable]()
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return posts
        }
        
        guard let url = URL(string: host + "/users/" + id + "/posts") else {
            print("url is empty")
            return posts
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
                }
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            let decoder = JSONDecoder()
            guard let tempPosts = try? decoder.decode([PostCodable].self, from: data) else {
                print("can't decode posts")
                taskGroup.leave()
                return
            }
            
            posts = tempPosts
            taskGroup.leave()
        }
        dataTask.resume()
        taskGroup.wait()
        
        return posts
    }
    
    static func feed() -> [PostCodable] {
        var posts: [PostCodable] = [PostCodable]()
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return posts
        }
        
        guard let url = URL(string: host + "/posts/feed") else {
            print("url is empty")
            return posts
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
                }
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            let decoder = JSONDecoder()
            guard let tempPosts = try? decoder.decode([PostCodable].self, from: data) else {
                print("can't decode posts")
                taskGroup.leave()
                return
            }

            posts = tempPosts
            taskGroup.leave()
        }
        dataTask.resume()
        taskGroup.wait()
        
        return posts
    }
    
    static func post(postId: String) -> PostCodable? {
        var post: PostCodable? = nil
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return post
        }
        
        guard let url = URL(string: host + "/posts/" + postId) else {
            print("url is empty")
            return post
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
                }
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            let decoder = JSONDecoder()
            guard let tempPost = try? decoder.decode(PostCodable.self, from: data) else {
                print("can't decode posts")
                taskGroup.leave()
                return
            }
            
            post = tempPost
            taskGroup.leave()
        }
        dataTask.resume()
        taskGroup.wait()
        
        return post
    }
    
    /**
     - Returns: If the answer is true the current user likes post.
     */
    static func like(postId: String) -> Bool {
        var success = false
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return success
        }
        
        guard let url = URL(string: host + "/posts/like") else {
            print("url is empty")
            return success
        }
        
        let jsonId = [ "postID" : postId]
        let idData = try? JSONSerialization.data(withJSONObject: jsonId, options: [])
        
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = idData
        
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
                taskGroup.leave()
            }
            
            success = true
        }
        dataTask.resume()
        taskGroup.wait()
        
        return success
    }
    
    /**
     - Returns: If the answer is true the current user unlikes post.
     */
    static func unlike(postId: String) -> Bool {
        var success = false
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return success
        }
        
        guard let url = URL(string: host + "/posts/unlike") else {
            print("url is empty")
            return success
        }
        
        let jsonId = [ "postID" : postId]
        let idData = try? JSONSerialization.data(withJSONObject: jsonId, options: [])
        
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = idData
        
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
                taskGroup.leave()
            }
            
            success = true
        }
        dataTask.resume()
        taskGroup.wait()
        
        return success
    }
    
    /**
     - Returns: Users who likes the post. If returns nil, the post was not found.
     */
    static func postLikes(postId id: String) -> [UserCodable]? {
        var users: [UserCodable]? = [UserCodable]()
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return users
        }
        
        guard let url = URL(string: host + "/posts/" + id + "/likes") else {
            print("url is empty")
            return users
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
                }
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            let decoder = JSONDecoder()
            guard let tempUsers = try? decoder.decode([UserCodable].self, from: data) else {
                print("can't decode posts")
                taskGroup.leave()
                return
            }
            
            users = tempUsers
            taskGroup.leave()
        }
        dataTask.resume()
        taskGroup.wait()
        
        return users
    }
    
    static func post(image: String, description: String = "") -> Bool {
        var success = false
        
        guard let token = self.token else {
            print("user did not sign in, token is nil")
            return success
        }
        
        guard let url = URL(string: host + "/posts/create") else {
            print("url is empty")
            return success
        }
        
        let jsonId = [
            "image" : image,
            "description" : description
        ]
        let idData = try? JSONSerialization.data(withJSONObject: jsonId, options: [])
        
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "token" : token
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = "POST"
        request.httpBody = idData
        
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
                taskGroup.leave()
            }
            
            success = true
        }
        dataTask.resume()
        taskGroup.wait()
        
        return success
    }
    
}
