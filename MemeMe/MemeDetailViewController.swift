//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Chris Amanse on 10/17/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = memeImage
    }
}
