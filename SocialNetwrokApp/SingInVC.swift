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

    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var pwdTxtField: CustomTextField!
    
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

                self.firebaseAuth(credential)
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: CustomButton) {
        
        // email authentication with firebase
        if let email = emailTxtField.text, let password = pwdTxtField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("Email user authentication with Firebase.")
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate with Firebase using email. Error: \(error)")
                        } else {
                            print("Successfully authenticated with Firebase using email.")
                        }
                    })
                }
            })
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

