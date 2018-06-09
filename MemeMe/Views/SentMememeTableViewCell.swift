//
//  SentMememeTableViewCell.swift
//  MemeMe
//
//  Created by Vivekananda Cherukuri on 05/10/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import UIKit

class SentMememeTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var memeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCellSelectionStyle.none

    }
    
    func setupCellWith(meMe:MemeModal)
    {
        
        memeImageView.image = meMe.memedImage
        descriptionTitle.text = meMe.topText + "..." + meMe.bottomText
    }

}
