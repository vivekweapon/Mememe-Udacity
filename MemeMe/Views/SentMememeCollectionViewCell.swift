//
//  SentMememeCollectionViewCell.swift
//  MemeMe
//
//  Created by Vivekananda Cherukuri on 05/10/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import UIKit

class SentMememeCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func setUpCell(meMe:MemeModal)
    {
        memeImageView.image = meMe.memedImage
    }
    
}
