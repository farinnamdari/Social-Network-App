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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var pwdTxtField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "showFeedVC", sender: nil)
        }
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
                    
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate with Firebase using email. Error: \(error)")
                        } else {
                            print("Successfully authenticated with Firebase using email.")
                            
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    // firebase authentication for facebook
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase. Error: \(error)")
            } else {
                print("Successfully authenticated with Firebase.")
                
                if let user = user {
                    let userData = ["provider": credential.provider]
                    
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        
        print("Data saved to keychain: \(keychainResult)")
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        performSegue(withIdentifier: "showFeedVC", sender: nil)
    }

}

