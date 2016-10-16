//
//  UIFontCollectionViewController.swift
//  MemeMe
//
//  Created by Chris Amanse on 10/15/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import UIKit

class UIFontCollectionViewController: UITableViewController {
    
    let fontCollection = UIFontCollection()
    var selectedFont: UIFont?
    
    weak var delegate: UIFontCollectionViewControllerDelegate?
    
    private var sectionForSectionIndexTitleCache = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didPressCancel(_:)))
        
        tableView.estimatedRowHeight = 50
        
        if let font = selectedFont {
            let familyName = font.familyName
            let fontFamily = UIFontFamily(name: familyName)
            
            if let section: Int = fontCollection.fontFamilies.index(of: fontFamily),
                let row = fontFamily.fontNames.index(of: font.fontName) {
                
                tableView.scrollToRow(at: IndexPath(row: row, section: section), at: .middle, animated: false)
            }
        }
    }
    
    func didPressCancel(_ sender: AnyObject) {
        dismiss(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fontCollection.fontFamilies.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontCollection.fontFamilies[section].fontNames.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fontCollection.fontFamilies[section].name
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return "ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters.map { String($0) }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let section = sectionForSectionIndexTitleCache[title] {
            return section
        }
        
        for (section, fontFamily) in fontCollection.fontFamilies.enumerated() {
            if fontFamily.name.hasPrefix(title) {
                sectionForSectionIndexTitleCache[title] = section
                
                return section
            }
            
            let current = fontFamily.name.characters.first.map { String($0) } ?? " "
            
            if current > title {
                sectionForSectionIndexTitleCache[title] = section
                
                return section
            }
        }
        
        return fontCollection.fontFamilies.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = reusedCell
        } else {
            let newCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            newCell.textLabel!.numberOfLines = 4
            
            cell = newCell
        }
        
        let fontName = fontCollection.fontFamilies[indexPath.section].fontNames[indexPath.row]
        
        let font = UIFont(name: fontName, size: 40)!
        
        cell.textLabel?.attributedText = NSAttributedString(string: fontName.humanReadable(), attributes: MemeTextAttributes(font: font).textAttributes)
        
        cell.accessoryType = font == selectedFont ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fontName = fontCollection.fontFamilies[indexPath.section].fontNames[indexPath.row]
        
        dismiss(animated: true) {
            self.delegate?.fontCollectionViewController(self, didChooseFontName: fontName)
        }
    }
}

protocol UIFontCollectionViewControllerDelegate: class {
    func fontCollectionViewController(_ contorller: UIFontCollectionViewController, didChooseFontName fontName: String)
}
