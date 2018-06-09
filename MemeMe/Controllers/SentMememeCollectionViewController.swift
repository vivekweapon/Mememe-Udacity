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
    @IBOutlet weak var mememeCollectionView: UICollectionView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        mememeCollectionView.register(UINib(nibName: "SentMememeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"memeCollectionViewCell")
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    override func viewWillAppear(_ animated: Bool)
   {
        super.viewWillAppear(animated)
       
        mememeCollectionView.reloadData()
        
    }
    
    //MARK: New Meme action.
    @objc func addTapped()
    {
        
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier:"MemeVC") as! MemeViewController
        vc.isCancelButtonEnabled = true//indicates whether cancel button should be enabled/disabled.
        
        let navController = UINavigationController(rootViewController:vc)
        present(navController, animated: true, completion: nil)
        
    }

}

extension SentMememeCollectionViewController:UICollectionViewDataSource,UICollectionViewDelegate
{
    //MARK: DATASOURCE METHODS.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return appDelegate.memeModalArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = mememeCollectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionViewCell", for: indexPath) as! SentMememeCollectionViewCell
            cell.setUpCell(meMe: appDelegate.memeModalArr[indexPath.row])
       
        return cell
        
    }
    
    //MARK:DELEGATE METHODS.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailMemeVC") as! DetailMememeViewController
        
        vc.selectedIndex = indexPath.row//this index is passed to ViewController which uses this information to populate the UI.
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}



