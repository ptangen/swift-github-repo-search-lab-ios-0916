//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
      
        // add the menu button to the nav bar
        let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchClicked))
        navigationItem.rightBarButtonItems = [searchButton]
        //searchButton.setTitleTextAttributes(menuButtonAttributes, for: .normal)
      
//        store.getRepositories {
//            OperationQueue.main.addOperation({ 
//                self.tableView.reloadData()
//            })
//        }
//        
//        GithubAPIClient.checkIfRepositoryIsStarred(name: "ptangen/FirstApp") {
//            print("The FirstApp repo is starred: \($0)")
//        }
        
//        GithubAPIClient.starResposity(name: "ptangen/FirstApp") {
//            print("Results of attempt to star the \($0) repo: \($1)")
//        }
        
//        GithubAPIClient.unstarResposity(name: "ptangen/FirstApp") {
//            print("Results of attempt to UNstar the \($0) repo: \($1)")
//        }
        
//        store.toggleStarStatus(name: "ptangen/FirstApp") {
//            print("The attempt to toggle the star was successful: \($0)")
        
//        GithubAPIClient.searchResposity(queryString: "ptangen", completion:{ //searchResposity
//            print("in completion")
//            dump($0)
//            self.tableView.reloadData()
//        })
        
//        store.getSearchResults(queryString: "apple") {
//          DispatchQueue.main.async {
//            self.tableView.reloadData()
//            //print("THIS IS THE COUNT FOR HOURLY TIMES:\(self.dataStore.hourlyDataArray.count)")
//          }
//        }
    }
  
    @IBAction func searchClicked(sender: UIBarButtonItem) {
      let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
      ac.addTextField()
      
      let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction!) in
        let answer = ac.textFields![0]
        if let searchString = answer.text {
          // send the request
          self.store.getSearchResults(queryString: searchString) {
            DispatchQueue.main.async {
              self.tableView.reloadData()
            }
          }
        }
      }
      ac.addAction(submitAction)
      present(ac, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
  
  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    
    //        store.toggleStarStatus(name: "ptangen/FirstApp") {
    //            print("The attempt to toggle the star was successful: \($0)")
    
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = UIColor.black
      cell.detailTextLabel?.textColor = UIColor.black
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = UIColor.gray
      cell.detailTextLabel?.textColor = UIColor.gray
    }
    
  }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        cell.textLabel?.text = store.repositories[indexPath.row].fullName
        return cell
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("didSelectRowAt")
    let repoName = store.repositories[indexPath.row].fullName
    print("repoName: \(repoName)")
    self.store.toggleStarStatus(name: repoName) {
      
      var message = String()
      if $0 {
        message = "The star for \(repoName) was toggled successfully."
      } else {
        message = "The star for \(repoName) was NOT toggled."
      }
      
      let alertController = UIAlertController(title: "Results", message: message, preferredStyle: .alert)
      
      let cancelAction = UIAlertAction(title: "Close", style: .cancel) { (action:UIAlertAction!) in
        print("you have pressed the Cancel button");
        print("self.tableView.indexPathForSelectedRow! \(self.tableView.indexPathForSelectedRow!.row)")
        // crash //self.tableView(tableView, willDeselectRowAt: self.tableView.indexPathForSelectedRow!)
        // no change //self.tableView.deselectRow(at: indexPath, animated: true)

      }
      alertController.addAction(cancelAction)
      self.present(alertController, animated: true, completion:nil)
    }
  }
}
