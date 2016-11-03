//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositories(_ completion: @escaping ([Any]) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }).resume()
    }
    
    // Create the method in GithubAPIClient called checkIfRepositoryIsStarred(fullName: completion:) that accepts a repo full name (e.g. githubUser/repoName) and checks to see if it is currently starred. The completion closure should take a boolean (true for starred, false otherwise).
    
    class func checkIfRepositoryIsStarred(name: String, _ completion: @escaping (Bool) -> ()) {
        
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(name)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { return }
        let session = URLSession.shared

        // add request if you need to send more than the URL
        var request = URLRequest(url: unwrappedURL)
        request.addValue("token \(Secrets.githubPersonalAccessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let datatask = session.dataTask(with: request, completionHandler:{ (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 204       { completion(true) }  // the result is in the response, not the data
            else if httpResponse.statusCode == 404  { completion(false) }
            else { print("Error: Status code was not 204 or 404 but rather: \(httpResponse.statusCode), error: \(error)")}
        })
        datatask.resume() // this is required to start the datatask
    }
    
    //Make a method in GithubAPIClient called starRepository(named: completion:) that stars a repository given its full name. Checkout the Github Documentation. The completion closure shouldn't return anything and shouldn't accept any parameters.
    class func starResposity(name: String, completion: @escaping (String,Bool) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(name)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { return }
        let session = URLSession.shared
        
        // add request if you need to send more than the URL
        var request = URLRequest(url: unwrappedURL)
        request.addValue("token \(Secrets.githubPersonalAccessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
            
        let datatask = session.dataTask(with: request, completionHandler:{ (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 204 { completion(name, true) } // the result is in the response, not the data
            else { print("Error: Status code was not 204 but rather: \(httpResponse.statusCode), error: \(error)")}
        })
        datatask.resume() // this is required to start the datatask
    }
    
    class func unstarResposity(name: String, completion: @escaping (String,Bool) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(name)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        if let unwrappedURL = url {
            // add request if you need to send more than the URL
            var request = URLRequest(url: unwrappedURL)
            request.addValue("token \(Secrets.githubPersonalAccessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("0", forHTTPHeaderField: "Content-Length")
            request.httpMethod = "DELETE"
            
            let datatask = session.dataTask(with: request, completionHandler:{ (data, response, error) in
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 204 { completion(name, true) }
                else { print("Error: SSStatus code was not 204 but rather: \(httpResponse.statusCode), error: \(error)")}
            })
            datatask.resume() // this is required to start the datatask
            
        } else { fatalError("Invalid URL") }
    }
    
    class func searchResposity(queryString:String, completion: @escaping ([String : Any]) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/search/repositories?q=\(queryString)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        //print("urlString \(urlString)")
        
        if let unwrappedURL = url {
            session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
                guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
                
                if let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if let responseDict = responseDict {
                        completion(responseDict)
                    }
                }
            }).resume()
        } else { fatalError("Invalid URL") }
    }
}












