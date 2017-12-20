//
//  FeedVC.swift
//  SocialNetwrokApp
//
//  Created by Fareen on 12/15/17.
//  Copyright © 2017 Fareen. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var newsFeedTableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
        
        // geting data from firebase
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.posts.append(post)
                    }
                }
            }
            
            self.newsFeedTableView.reloadData()
        })
    }
    
    /* UITableViewDelegate/ UITableViewDataSource methods */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = newsFeedTableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)
            
            return cell
        }
        
        return PostCell()
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.remove(key: KEY_UID)
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "showSignInVC", sender: nil)
    }

}
