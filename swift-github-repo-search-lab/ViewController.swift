//
//  ViewController.swift
//  swift-github-repo-search-lab
//
//  Created by Ian Rahman on 10/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(Secrets.githubAPIURL)
        Alamofire.request(Secrets.githubAPIURL).responseJSON { response in
            print("in request")
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            //print(response.error)    // any error, if one exists
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

