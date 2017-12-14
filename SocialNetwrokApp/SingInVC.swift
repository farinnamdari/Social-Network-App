//
//  ViewController.swift
//  SocialNetwrokApp
//
//  Created by Fareen on 12/12/17.
//  Copyright © 2017 Fareen. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func facebookBtnTapped(_ sender: RoundButton) {
        let fbLogin = FBSDKLoginManager()
        
        // facebook authentication
        fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to authenticate with Facebook. Error: \(error)")
            } else if (result?.isCancelled)! {
                print("User cancelled Facebook authentication.")
            } else {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                print("Successfully authenticated with Facebook.")
                self.firebaseAuth(credential)
            }
        }
    }
    
    // firebase authentication
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase. Error: \(error)")
            } else {
                print("Successfully authenticated with Firebase.")
            }
        })
    }

}

