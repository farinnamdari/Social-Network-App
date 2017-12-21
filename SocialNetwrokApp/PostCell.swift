//
//  PostCell.swift
//  SocialNetwrokApp
//
//  Created by Fareen on 12/18/17.
//  Copyright © 2017 Fareen. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var captionTxtView: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        print("POST imageURL:", post.imageUrl)
        
        captionTxtView.text = post.caption
        likesLbl.text = "\(post.likes)"
        
        if img != nil {                                                         // image in cache
            postImg.image = img
        } else {                                                                // image not in cache
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from firebase storage. - Error: \(error)")
                } else {
                    print("Image downloaded from firebase storage.")
                    
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }


}
