//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Chris Amanse on 10/17/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCell"

class MemesCollectionViewController: UICollectionViewController {
    let collection = MemeCollection.default
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 1.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView!.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
    
        let meme = collection.memes[indexPath.row]
        
        let attributes = MemeTextAttributes(font: cell.topLabel.font)
        
        cell.topLabel.attributedText = attributes.attributedText(for: meme.topText)
        cell.bottomLabel.attributedText = attributes.attributedText(for: meme.bottomText)
        cell.memeImageView.image = meme.image
        
        return cell
    }
}
