//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Chris Amanse on 10/16/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import UIKit

class MemesTableViewController: UITableViewController {
    
    let collection = MemeCollection.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as! MemeTableViewCell
        
        let meme = collection.memes[indexPath.row]
        
        let font: UIFont = cell.topLabel.font
        
        // Add line break mode in paragraph style of attributes
        var attributes = MemeTextAttributes(font: font).textAttributes
        let paragraphStyle = (attributes[NSParagraphStyleAttributeName] as! NSParagraphStyle).mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingMiddle
        
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        
        cell.topLabel.attributedText = NSAttributedString(string: meme.topText, attributes: attributes)
        cell.bottomLabel.attributedText = NSAttributedString(string: meme.bottomText, attributes: attributes)
        cell.memeLabel.text = meme.topText + "..." + meme.bottomText
        cell.memeImageView.image = meme.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
