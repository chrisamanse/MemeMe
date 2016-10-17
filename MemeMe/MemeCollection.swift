//
//  MemeCollection.swift
//  MemeMe
//
//  Created by Chris Amanse on 10/16/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import Foundation

class MemeCollection {
    static let `default` = MemeCollection()
    
    var memes = [Meme]()
    
    private init() {}
}
