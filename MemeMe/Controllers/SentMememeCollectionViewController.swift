//
//  SentMememeCollectionViewController.swift
//  MemeMe
//
//  Created by Vivekananda Cherukuri on 05/10/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import Foundation
import UIKit

class SentMememeCollectionViewController:UIViewController {
    
    @IBOutlet weak var collectionViewFlowLayout:UICollectionViewFlowLayout!
   
    var memeModalArr:Array = [MemeModal]()
    let defaults = UserDefaults.standard


    @IBOutlet weak var mememeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        mememeCollectionView.register(UINib(nibName: "SentMememeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"memeCollectionViewCell")
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if let memeData = defaults.object(forKey: "MemeModal") as? Data {
            memeModalArr = NSKeyedUnarchiver.unarchiveObject(with: memeData) as! [MemeModal]
        }
        mememeCollectionView.reloadData()
        
    }
    
    //MARK:New Meme action.
    @objc func addTapped() {
        
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier:"MemeVC") as! ViewController
        vc.isCancelButtonEnabled = true//indicates whether cancel button should be enabled/disabled.
        
        let navController = UINavigationController(rootViewController:vc)
        self.present(navController, animated: true, completion: nil)
        
    }

}

extension SentMememeCollectionViewController:UICollectionViewDataSource,UICollectionViewDelegate
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memeModalArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mememeCollectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionViewCell", for: indexPath) as! SentMememeCollectionViewCell
            cell.memeImageView.image = memeModalArr[indexPath.row].memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailMemeVC") as! DetailMememeViewController
        
        vc.selectedIndex = indexPath.row//this index is passed to ViewController which uses this information to populate the UI.
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}



