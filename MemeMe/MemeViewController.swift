//
//  ViewController.swift
//  MemeMe
//
//  Created by Chris Amanse on 10/15/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var fontsBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMemeTextAttributes(MemeTextAttributes(font: topTextField.font!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeKeyboardNotifications()
    }
    
    @IBAction func didTapChoosePhoto(_ sender: UIBarButtonItem) {
        print("did tap image")
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            // Immediately show image picker, since camera is not available anyway
            showImagePicker()
            
            return
        }
        
        let alertController = UIAlertController(title: "Choose Photo", message: "Choose a photo for your meme.", preferredStyle: .actionSheet)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.barButtonItem = cameraBarButtonItem
        }
        
        let camera = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.showImagePicker(useCamera: true)
        }
        
        let imagePicker = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.showImagePicker()
        }
        
        alertController.addAction(camera)
        alertController.addAction(imagePicker)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    @IBAction func didTapShare(_ sender: UIBarButtonItem) {
        guard let image = generateMeme() else {
            showErrorAlert(title: "Error", message: "Something went terribly wrong. Failed to generate meme.")
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityController.popoverPresentationController?.barButtonItem = shareBarButtonItem
        }
        
        present(activityController, animated: true)
    }
    
    @IBAction func didTapFonts(_ sender: UIBarButtonItem) {
        let fontCollectionVC = UIFontCollectionViewController()
        
        fontCollectionVC.navigationItem.title = "Fonts"
        
        fontCollectionVC.delegate = self
        fontCollectionVC.selectedFont = topTextField.font
        
        let navigationController = UINavigationController(rootViewController: fontCollectionVC)
        
        navigationController.modalPresentationStyle = .popover
        navigationController.popoverPresentationController?.barButtonItem = fontsBarButtonItem
        
        present(navigationController, animated: true)
    }
    
    func showImagePicker(useCamera: Bool = false) {
        let imagePickerController = UIImagePickerController()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imagePickerController.modalPresentationStyle = .popover
            imagePickerController.popoverPresentationController?.barButtonItem = cameraBarButtonItem
        }
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = useCamera ? .camera : .photoLibrary
        
        present(imagePickerController, animated: true)
    }
    
    func generateMeme() -> UIImage? {
        UIGraphicsBeginImageContext(canvasView.bounds.size)
        defer {
            UIGraphicsEndImageContext()
        }
        
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
    
    func setMemeTextAttributes(_ attributes: MemeTextAttributes) {
        let dict = attributes.textAttributes
        
        topTextField.defaultTextAttributes = dict
        bottomTextField.defaultTextAttributes = dict
    }
    
    func showErrorAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: completion)
    }
}

extension MemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        self.dismiss(animated: true)
    }
}

// MARK: Text Field Delegate

extension MemeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == topTextField {
            bottomTextField.becomeFirstResponder()
            
            return false
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == topTextField && textField.text == DefaultInputs.topTextField) ||
            (textField == bottomTextField && textField.text == DefaultInputs.bottomTextField) {
            textField.text = ""
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let characterCount = textField.text?.characters.count ?? 0
        
        if textField == topTextField && characterCount == 0 {
            textField.text = DefaultInputs.topTextField
        } else if textField == bottomTextField && characterCount == 0 {
            textField.text = DefaultInputs.bottomTextField
        }
        
        return true
    }
    
    enum DefaultInputs {
        static let topTextField: String = "TOP"
        static let bottomTextField: String = "BOTTOM"
    }
}

// MARK: Font collection view controller delegate

extension MemeViewController: UIFontCollectionViewControllerDelegate {
    func fontCollectionViewController(_ contorller: UIFontCollectionViewController, didChooseFontName fontName: String) {
        setMemeTextAttributes(MemeTextAttributes(font: UIFont(name: fontName, size: 40)!))
    }
}

// MARK: Keyboard

extension MemeViewController {
    func subscribeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("Keyboard will show")
        guard bottomTextField.isFirstResponder && view.frame.origin.y == 0 else {
            return
        }
        
        print("bottom text field is first responder")
        
        view.frame.origin.y -= keyboardHeight(in: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("Keyboard will hide")
        
        view.frame.origin.y = 0
    }
    
    func keyboardHeight(in notification: NSNotification) -> CGFloat {
        return (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
    }
}
