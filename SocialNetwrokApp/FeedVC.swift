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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageAddView: CircleView!
    @IBOutlet weak var captionTxtField: CustomTextField!
    @IBOutlet weak var newsFeedTableView: UITableView!
 
    var imagePicker: UIImagePickerController!
    var posts = [Post]()
    var imageSelected = false
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        // geting data from firebase
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            
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
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            
            return cell
        }
        
        return PostCell()
    }
    
    /* UIImagePickerControllerDelegate functions */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAddView.image = image
            imageSelected = true
        } else {
            print("Valid image was not selected!")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: UITapGestureRecognizer) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.remove(key: KEY_UID)
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "showSignInVC", sender: nil)
    }

    @IBAction func addImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: RoundButton) {
        guard let caption = captionTxtField.text, caption != "" else {
            print("Caption must be entered!")
            return
        }
        
        guard let image = imageAddView.image, imageSelected else {
            print("An image must be selected!")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Unable to upload image to Firebase storage. - Error: \(error)")
                } else {
                    print("Successfully upload image to Firebase storage.")
                    
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadUrl {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        let post: Dictionary<String, AnyObject> = [
            "caption": captionTxtField.text as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        
        firebasePost.setValue(post)
        
        // reset the fields after new post
        captionTxtField.text = ""
        imageSelected = false
        imageAddView.image = UIImage(named: "add-image")
        
        newsFeedTableView.reloadData()
    }
}
