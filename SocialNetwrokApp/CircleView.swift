//
//  CircleView.swift
//  SocialNetwrokApp
//
//  Created by Fareen on 12/18/17.
//  Copyright © 2017 Fareen. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
