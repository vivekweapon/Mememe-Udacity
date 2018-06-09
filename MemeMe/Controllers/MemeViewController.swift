//
//  ViewController.swift
//  MemeMe
//
//  Created by Vivekananda Cherukuri on 03/10/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var memeImageView: UIImageView!
    
    
    var picker:UIImagePickerController? = UIImagePickerController()
    var selectedImage = UIImage()
    var memeModalArr:Array = [MemeModal]()
    let defaults = UserDefaults.standard
    var shareButton:UIBarButtonItem!
    var cancelButton:UIBarButtonItem!
    var selectIndex:Int!
    let userDefaults = UserDefaults.standard
    var isCancelButtonEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let memeData = defaults.object(forKey: "MemeModal") as? Data {
              memeModalArr = NSKeyedUnarchiver.unarchiveObject(with: memeData) as! Array<MemeModal>
          
        }

         shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action:#selector(self.shareButtonTapped))
        
         cancelButton = UIBarButtonItem(title:"Cancel",style:.plain,target:self,action:#selector(self.cancelButtonTapped))
        
        if(isCancelButtonEnabled == true)
        {
            cancelButton.isEnabled = true
        }
        else
        {
            cancelButton.isEnabled = false
        }
        
        
        self.navigationItem.leftBarButtonItem = shareButton
        self.navigationItem.rightBarButtonItem = cancelButton
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue:UIColor.black,NSAttributedStringKey.foregroundColor.rawValue:UIColor.white,NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue:-2.0]
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
       
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        bottomTextField.delegate = self
        topTextField.delegate = self
        
        bottomTextField.textAlignment = NSTextAlignment.center
        topTextField.textAlignment = NSTextAlignment.center
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
       
        //selectedIndex from DetailViewController
        if(selectIndex != nil)
        {
            memeImageView.image = memeModalArr[selectIndex].originalImage
            topTextField.text = memeModalArr[selectIndex].topText
            bottomTextField.text = memeModalArr[selectIndex].bottomText
        }
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        isCancelButtonEnabled = false
        unsubscribeFromKeyboardNotifications()
    }
    
    
   
    
    
    //MARK:Keyboard observers
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK:Keyboard notifications.
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if(bottomTextField.isFirstResponder == true) {
            view.frame.origin.y -= getKeyboardHeight(notification)
            
        }
        
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    //MARK: Camera or Album action methods.
    @IBAction func openCameraButtonTapped(_ sender: Any) {
       
        self.setSourceType(sourcetype: .camera)

    }
    
    @IBAction func showAlbumTapped(_ sender: Any) {
      
        self.setSourceType(sourcetype: .photoLibrary)
        
    }
    
    func setSourceType(sourcetype:UIImagePickerControllerSourceType)
    {
        picker?.delegate = self
        picker?.sourceType = sourcetype
        present(picker!, animated: true, completion: nil)

     }
    
    
    //MARK:Barbuttonitem action methods.
    @objc func shareButtonTapped() {
        
        let activityVC = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        //Excluded Activities
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        activityVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                
                let storyBoard = UIStoryboard(name:"Main",bundle:nil)
                let tabBarVC = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabBarVC
            }
        }
        
        self.present(activityVC, animated: true, completion: nil)
        self.save()

        
    }
    
   @objc func cancelButtonTapped() {
    
        self.dismiss(animated: true, completion: nil)
    
}
    
   //MARK:Image picker delegate methods.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = selectedImage
            
            }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK:Textfield delegate methods.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:Save
    func save() {
        // Create the meme.
       
        let meMe = MemeModal(topTextField.text!,bottomTextField.text!,memeImageView.image!,generateMemedImage())
      
        //Checking if ModalArr has any Memes.If Memes exist then appends the new meme to MemeModalArr and then Archives the array and saves it userdefaults.
        if memeModalArr.count > 0 {

            memeModalArr.append(meMe)

            let memeData = NSKeyedArchiver.archivedData(withRootObject: memeModalArr)
            userDefaults.set(memeData, forKey: "MemeModal")
            userDefaults.synchronize()

        }
        else
        {
            //when ModalArray is Empty creates an empty array which holds Meme Modal Objects.appends first meme modal object to empty modal array and archives it and saves to userdefaults.
            var modalArray = [MemeModal]()
            modalArray.append(meMe)
            let memeData = NSKeyedArchiver.archivedData(withRootObject: modalArray)

            userDefaults.set(memeData, forKey: "MemeModal")
            userDefaults.synchronize()

        }

    }
    
        func generateMemedImage() -> UIImage {
            
            self.navigationController?.isNavigationBarHidden = true
            self.bottomToolBar.isHidden = true
            // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            
            self.navigationController?.isNavigationBarHidden = false
            self.bottomToolBar.isHidden = false
            
            return memedImage
        }
}
