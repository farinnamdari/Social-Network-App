//
//  PostCell.swift
//  SocialNetwrokApp
//
//  Created by Fareen on 12/18/17.
//  Copyright © 2017 Fareen. All rights reserved.
//

import UIKit

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
    
    func configureCell(post: Post) {
        self.post = post
        
        captionTxtView.text = post.caption
        likesLbl.text = "\(post.likes)"
    }


}
