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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signOutTapped(_ sender: UIButton) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.remove(key: KEY_UID)
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "showSignInVC", sender: nil)
    }

}
