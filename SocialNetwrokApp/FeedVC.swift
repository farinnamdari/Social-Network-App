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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
    }
    
    /* UITableViewDelegate/ UITableViewDataSource methods */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return newsFeedTableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.remove(key: KEY_UID)
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "showSignInVC", sender: nil)
    }

}
