//
//  UIFontCollection.swift
//  MemeMe
//
//  Created by Chris Amanse on 10/15/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import UIKit

public class UIFontCollection {
    public private(set) var fontFamilies: [UIFontFamily]
    
    public init() {
        let familyNames = UIFont.familyNames
        
        fontFamilies = familyNames.sorted().lazy
            .map {
                UIFontFamily(name: $0)
            }
            .filter {
                $0.fontNames.count > 0
        }
    }
}

extension UIFontCollection: CustomStringConvertible {
    public var description: String {
        return fontFamilies.description
    }
}

public struct UIFontFamily {
    public var name: String
    
    public private(set) var fontNames: [String]
    
    public init(name: String) {
        self.name = name
        
        self.fontNames = UIFont.fontNames(forFamilyName: name).sorted {
            switch ($0.contains("-"), $1.contains("-")) {
            case (true, false):
                // right doesn't contain hyphen so it should come before left
                return false
            case (false, true):
                // left doesn't contain hyphen, so it is in the right position
                return true
            default:
                // if both contains hyphen or both does not have hyphen, normal compare
                return $0 < $1
            }
        }
    }
}

extension UIFontFamily: Equatable {
    public static func ==(lhs: UIFontFamily, rhs: UIFontFamily) -> Bool {
        return lhs.name == rhs.name
    }
}

extension UIFontFamily: CustomStringConvertible {
    public var description: String {
        return "{\(name): \(fontNames)}"
    }
}
