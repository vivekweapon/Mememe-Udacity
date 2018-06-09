//
//  DetailMememeViewController.swift
//  MemeMe
//
//  Created by Vivekananda Cherukuri on 22/10/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import Foundation
import UIKit

class DetailMememeViewController:UIViewController
{
    @IBOutlet weak var detailImageView:UIImageView!
    
    var memedImage:UIImage!
    var selectedIndex:Int!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageView.image = appDelegate.memeModalArr[selectedIndex].memedImage

        let editBarButtItem = UIBarButtonItem(title: "edit", style: .plain, target: self, action:#selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editBarButtItem
        
    }
    
    @objc func editButtonTapped()
    {
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MemeVC") as! MemeViewController
       
        vc.selectIndex = selectedIndex//this index is passed to ViewController which uses this information to populate the UI.
        vc.isCancelButtonEnabled = true//whether to enable/disable cancel button
        
        let navController = UINavigationController(rootViewController:vc)
        present(navController, animated: true, completion: nil)
    }
}
