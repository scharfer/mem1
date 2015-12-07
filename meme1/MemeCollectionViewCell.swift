//
//  MemeCollectionViewCell.swift
//  meme1
//
//  Created by Evan Scharfer on 12/7/15.
//  Copyright © 2015 Evan Scharfer. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    var topText : String!
    var bottomText : String!
    
    func setText(topString : String, bottomString: String ) {
        topText = topString
        bottomText = bottomString
    }
    
}
