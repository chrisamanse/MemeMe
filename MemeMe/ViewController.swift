//
//  ViewController.swift
//  MemeMe
//
//  Created by Chris Amanse on 10/15/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapChoosePhoto(_ sender: AnyObject) {
        print("did tap image")
        
        let alertController = UIAlertController(title: "Choose Photo", message: "Choose a photo for your meme.", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIAlertAction(title: "Take Photo", style: .default) { _ in
                self.showImagePicker(useCamera: true)
            }
            
            alertController.addAction(camera)
        }
        
        let imagePicker = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.showImagePicker()
        }
        alertController.addAction(imagePicker)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    @IBAction func didTapShare(_ sender: AnyObject) {
        guard let image = generateMeme() else {
            showErrorAlert(title: "Error", message: "Something went terribly wrong. Failed to generate meme.")
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        present(activityController, animated: true)
    }
    
    func showImagePicker(useCamera: Bool = false) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = useCamera ? .camera : .photoLibrary
        
        present(imagePickerController, animated: true)
    }
    
    func generateMeme() -> UIImage? {
        UIGraphicsBeginImageContext(view.bounds.size)
        defer {
            UIGraphicsEndImageContext()
        }
        
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
    
    func showErrorAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: completion)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        
        imageView.image = image
        
        self.dismiss(animated: true)
    }
}
