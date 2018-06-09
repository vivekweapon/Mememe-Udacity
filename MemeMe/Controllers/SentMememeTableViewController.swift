//
//  SentMememeTableViewController.swift
//  MemeMe
//
//  Created by Vivekananda Cherukuri on 05/10/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import Foundation
import UIKit

class SentMememeTableViewController:UIViewController {
    
    var memeModalArr:Array = [MemeModal]()
    @IBOutlet weak var mememeTableView: UITableView!
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //accesing modal data from Userdefaults.
        
        if let memeData = defaults.object(forKey: "MemeModal") as? Data {
            memeModalArr = NSKeyedUnarchiver.unarchiveObject(with: memeData) as! Array<MemeModal>
        }
        else {
            return
        }
       //registering tableview with cell
        mememeTableView.register(UINib(nibName: "SentMememeTableViewCell", bundle: nil), forCellReuseIdentifier: "memeTableViewCell")
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        self.navigationItem.rightBarButtonItem = rightBarButton

    }
    
    //MARK:New Meme Action.
    @objc func addTapped() {
        
         let storyBoard = UIStoryboard(name:"Main",bundle:nil)
      
         let vc = storyBoard.instantiateViewController(withIdentifier:"MemeVC") as! ViewController
         vc.isCancelButtonEnabled = true//indicates cancel button is enabled/disabled.
        
        let navController = UINavigationController(rootViewController:vc)
        self.present(navController, animated: true, completion: nil)
        
    }
}

extension SentMememeTableViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return memeModalArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mememeTableView.dequeueReusableCell(withIdentifier: "memeTableViewCell", for: indexPath) as! SentMememeTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.memeImageView.image = memeModalArr[indexPath.row].memedImage
        cell.descriptionTitle.text = memeModalArr[indexPath.row].topText + "..." + memeModalArr[indexPath.row].bottomText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailMemeVC") as! DetailMememeViewController
        
        vc.selectedIndex = indexPath.row//this index is passed to ViewController which uses this information to populate the UI.
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            memeModalArr.remove(at: indexPath.row)//delete object from modalArr
            mememeTableView.deleteRows(at: [indexPath], with: .fade)//tableView delete
            
            //Archving new modal to UserDefaults.
            let memeData = NSKeyedArchiver.archivedData(withRootObject: memeModalArr)
            defaults.set(memeData, forKey: "MemeModal")
            defaults.synchronize()
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
