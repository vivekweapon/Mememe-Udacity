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
    
    @IBOutlet weak var mememeTableView: UITableView!
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isModalEmpty:Bool!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
     //Registering tableview with cell
        mememeTableView.register(UINib(nibName: "SentMememeTableViewCell", bundle: nil), forCellReuseIdentifier: "memeTableViewCell")
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = rightBarButton

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
      
        if(appDelegate.memeModalArr.count == 0)
        {
            self.presentMemeViewController()
            isModalEmpty = true
        }
        else
        {
            isModalEmpty = false
        }
        
        mememeTableView.reloadData()
        
    }
    
       func presentMemeViewController()
    {
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier:"MemeVC") as! MemeViewController
        vc.isCancelButtonEnabled = true//indicates cancel button is enabled/disabled.
       
        if(isModalEmpty == true)
        {
            vc.isCancelButtonEnabled = false
        }
        else
        {
            vc.isCancelButtonEnabled = true
        }
       
        let navController = UINavigationController(rootViewController:vc)
        present(navController, animated: true, completion: nil)
    }
    
    //MARK: New Meme Action.
    @objc func addTapped()
    {
        
        presentMemeViewController()
    }
}

extension SentMememeTableViewController:UITableViewDataSource,UITableViewDelegate
{
    //MARK: DATASOURCE METHODS
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 150.0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
        return appDelegate.memeModalArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = mememeTableView.dequeueReusableCell(withIdentifier: "memeTableViewCell", for: indexPath) as! SentMememeTableViewCell
        cell.setupCellWith(meMe: appDelegate.memeModalArr[indexPath.row])
        
        return cell
    }
    
    //MARK: DELEGATE METHODS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailMemeVC") as! DetailMememeViewController
        vc.selectedIndex = indexPath.row//this index is passed to ViewController which uses this information to populate the UI.
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
     {
        if editingStyle == .delete {
            
            appDelegate.memeModalArr.remove(at: indexPath.row)//delete object from modalArr
            mememeTableView.deleteRows(at: [indexPath], with: .fade)//tableView delete
        
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}
