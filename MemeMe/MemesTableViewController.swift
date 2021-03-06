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
        
        let attributes = MemeTextAttributes(font: cell.topLabel.font)
        
        cell.topLabel.attributedText = attributes.attributedText(for: meme.topText)
        cell.bottomLabel.attributedText = attributes.attributedText(for: meme.bottomText)
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
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail", let destinationVC = segue.destination as? MemeDetailViewController {
            let selectedMeme = collection.memes[tableView.indexPathForSelectedRow?.row ?? 0]
            
            destinationVC.memeImage = selectedMeme.memedImage
        }
    }
}
