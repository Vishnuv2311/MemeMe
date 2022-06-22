//
//  ViewController.swift
//  MemeMe
//
//  Created by Vishnu V on 16/06/22.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var camerButton: UIBarButtonItem!
    @IBOutlet weak var topMemeText: UITextField!
    @IBOutlet weak var bottomMemeText: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    private let textDelegate = TextDelegate()
    
    private let memeTextAttributes : [NSAttributedString.Key:Any] = [
        NSAttributedString.Key.backgroundColor: UIColor.clear,
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor :UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -2]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        camerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topMemeText.delegate = textDelegate
        bottomMemeText.delegate = textDelegate
        
        topMemeText.defaultTextAttributes = memeTextAttributes
        bottomMemeText.defaultTextAttributes = memeTextAttributes
        
        shareButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func save(){
        let meme = Meme(topText: topMemeText.text!, bottomText: bottomMemeText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        //hide toolbar and navbar
       hideToolBarNavBar(isHidden: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in:self.view.frame,afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //showw toolbar and navbar
        hideToolBarNavBar(isHidden: false)
        
        return memedImage
    }
    
    func hideToolBarNavBar(isHidden:Bool){
        self.toolBar.isHidden = isHidden
        self.navBar.isHidden = isHidden
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    @IBAction func pickFromCamera(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let imageItem :[AnyObject] = [generateMemedImage() as AnyObject]
    let shareController = UIActivityViewController(activityItems: imageItem, applicationActivities: nil)
        
        present(shareController, animated: true, completion: nil)
        
        shareController.completionWithItemsHandler = {_,complete,_,_ in
            self.save()
        }
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification,object: nil)
    }
    
    @objc func keyboardWillShow(_ nofification:Notification){
        view.frame.origin.y -= getKeyboardHeight(nofification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat{
        let userInfo  = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
}

