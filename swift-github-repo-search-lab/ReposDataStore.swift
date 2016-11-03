//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositories(_ completion: @escaping () -> ()) {
        GithubAPIClient.getRepositories { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
            }
            completion()
        }
    }
    
    func getSearchResults(queryString:String, completion: @escaping () -> ()) {
        GithubAPIClient.searchResposity(queryString: queryString) { (repoDict) in
            self.repositories.removeAll()
            if let repoDictArray = repoDict["items"] {
                if let repoDict2 = repoDictArray as? [Any] {
                    for dictionary in repoDict2 {
                        let repository = GithubRepository(dictionary: dictionary as! [String : Any])
                        self.repositories.append(repository)
                    }
                }
            }
            completion()
        }
    }
    
    //Create a method in ReposDataStore called toggleStarStatus(for: completion:) that, given a GithubRepository object, checks to see if it's starred or not and then either stars or unstars the repo. That is, it should toggle the star on a given repository. In the completion closure, there should be a Bool parameter called starred that is true if the repo was just starred, and false if it was just unstarred.
    
    func toggleStarStatus(name: String, _ completion: @escaping (Bool) -> ()) {
        
        GithubAPIClient.checkIfRepositoryIsStarred(name: name) { (isStarred) in
            if isStarred == true {
                GithubAPIClient.unstarResposity(name: name) { (results) in
                    completion(true)
                }
            } else {
                GithubAPIClient.starResposity(name: name) { (results) in
                    completion(true)
                }
            }
        }
    }
}
