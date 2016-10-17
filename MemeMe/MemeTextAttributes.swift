//
//  MemeTextAttributes.swift
//  MemeMe
//
//  Created by Chris Amanse on 10/15/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import Foundation
import UIKit

public struct MemeTextAttributes {
    public var font: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    
    public var strokeColor: UIColor = .black
    public var strokeWidth: Float = -2.0
    
    public var foregroundColor: UIColor = .white
    
    public var alignment: NSTextAlignment = .center
    public var lineBreakMode: NSLineBreakMode = .byTruncatingMiddle
    
    internal var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        style.lineBreakMode = lineBreakMode
        
        return style
    }
    
    public init(font: UIFont) {
        self.font = font
    }
    
    public var textAttributes: [String: Any] {
        return [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSStrokeColorAttributeName: strokeColor,
            NSStrokeWidthAttributeName: strokeWidth,
            NSForegroundColorAttributeName: foregroundColor,
            NSFontAttributeName: font
        ]
    }
    
    public func attributedText(for string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: textAttributes)
    }
}
