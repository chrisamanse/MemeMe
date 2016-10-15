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
    
    func showImagePicker(useCamera: Bool = false) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = useCamera ? .camera : .photoLibrary
        
        present(imagePickerController, animated: true)
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
