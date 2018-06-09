//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Vivekananda Cherukuri on 03/10/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate
{
    
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextFieldTopConstarint:NSLayoutConstraint!
    
    
    var picker:UIImagePickerController? = UIImagePickerController()
    var selectedImage = UIImage()
    var shareButton:UIBarButtonItem!
    var cancelButton:UIBarButtonItem!
    var selectIndex:Int!
    var isCancelButtonEnabled = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        picker?.delegate = self
        
         shareButton
            = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareButtonTapped))
        
         cancelButton = UIBarButtonItem(title:"Cancel",style:.plain,target:self,action:#selector(self.cancelButtonTapped))
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        if isCancelButtonEnabled
        {
            cancelButton.isEnabled = true
        }
        else
        {
            cancelButton.isEnabled = false
        }
        
        configureTextField(textField: topTextField)
        configureTextField(textField: bottomTextField)
        
        navigationItem.leftBarButtonItem = shareButton
        navigationItem.rightBarButtonItem = cancelButton

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(animated)
       
        if(selectIndex != nil)
        {

            memeImageView.image = appDelegate.memeModalArr[selectIndex].originalImage
            topTextField.text = appDelegate.memeModalArr[selectIndex].topText
            bottomTextField.text = appDelegate.memeModalArr[selectIndex].bottomText
            selectIndex = nil
            
        }
        
        if(appDelegate.memeModalArr.count == 0)
        {
            cancelButton.isEnabled = false
        }
        else
        {
            cancelButton.isEnabled = true
        }
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        
        super.viewWillDisappear(animated)
        
        isCancelButtonEnabled = false
        unsubscribeFromKeyboardNotifications()
        
    }
    
    deinit
   {
       memeImageView.image = nil
   }
    
    func configureTextField(textField: UITextField)
    {
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue:UIColor.black,NSAttributedStringKey.foregroundColor.rawValue:UIColor.white,NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue:-2.0]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = NSTextAlignment.center
    }
    
    
    //MARK:Keyboard observers
    
    func subscribeToKeyboardNotifications()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK:Keyboard notifications.
    @objc func keyboardWillShow(_ notification:Notification)
    {
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
        {
            
            if(bottomTextField.isFirstResponder == true)
            {
                view.frame.origin.y -=
                    
                getKeyboardHeight(notification)/2
                
            }
            
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
        {
            
            if(bottomTextField.isFirstResponder == true)
          {
                view.frame.origin.y -=
                
                getKeyboardHeight(notification)/2
                
           }
        }
        
        else
        {
            if(bottomTextField.isFirstResponder == true)
            {
                view.frame.origin.y -=
                    
                    getKeyboardHeight(notification)
                
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification)
    {
        
        view.frame.origin.y = 0.0

    }
    
    //MARK:Get keyboard Height.
    func getKeyboardHeight(_ notification:Notification) -> CGFloat
    {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    //MARK: Camera or Album action methods.
    @IBAction func openCameraButtonTapped(_ sender: Any)
    {
       
        setSourceType(sourcetype: .camera)

    }
    
    @IBAction func showAlbumTapped(_ sender: Any)
    {
      
        setSourceType(sourcetype: .photoLibrary)
        
    }
    
    func setSourceType(sourcetype:UIImagePickerControllerSourceType)
    {
        picker?.sourceType = sourcetype
        picker?.allowsEditing = false

        if(sourcetype == .camera) {
            picker?.sourceType = sourcetype
            picker?.cameraCaptureMode = .photo
            picker?.modalPresentationStyle = .fullScreen
        }
        else
        {
            picker?.sourceType = .photoLibrary
            picker?.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        }
        present(picker!, animated: true, completion: nil)

     }
    
    
    //MARK:Barbuttonitem action methods.
    @objc func shareButtonTapped()
    {
        
        if(memeImageView.image != nil)
        {
            let activityVC = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            activityVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                if completed == true {
                    
                    self.save()//append to ModalArr.This is called after share activtiy is completed as it is in completion handler of the activity view.

                }
            }
            
            present(activityVC, animated: true, completion: nil)
        }
       
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please choose an image.", preferredStyle: .alert)

            let errorAction = UIAlertAction(
            title: "OK", style: UIAlertActionStyle.default) { (action) in
                
            }
            
            alert.addAction(errorAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func cancelButtonTapped()
    {

        dismiss(animated: true, completion: nil)
    }
    
   //MARK:Image picker delegate methods.
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
       
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            performUIUpdatesOnMain {
                
                self.memeImageView.image = selectedImage

            }
            
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK:Textfield delegate methods.
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:Save
    func save()
    {
        // Create the meMe.Meme will never be nil because we show an alert when image is not selected.
        
        let meMe = MemeModal(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: generateMemedImage())
            appDelegate.memeModalArr.append(meMe)
        
        dismiss(animated: true, completion: nil)


    }
    //MARK:Genearte Meme Image
    func generateMemedImage() -> UIImage
    {
            
            navigationController?.isNavigationBarHidden = true
            bottomToolBar.isHidden = true
            // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
        
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
            UIGraphicsEndImageContext()
        
            navigationController?.isNavigationBarHidden = false
            bottomToolBar.isHidden = false
            return memedImage
            
    }
}
