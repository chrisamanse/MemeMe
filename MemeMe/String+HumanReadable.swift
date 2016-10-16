//
//  String+HumanReadable.swift
//  MemeMe
//
//  Created by Chris Amanse on 10/15/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import Foundation

extension String {
    var isLowercase: Bool {
        return lowercased() == self
    }
    var isUppercase: Bool {
        return !isLowercase
    }
    
    private func isSeparator(_ character: Character) -> Bool {
        switch character {
        case " ", "_", "-":
            return true
        default:
            return false
        }
    }
    
    func humanReadable() -> String {
        // Convert strings to a more readable format
        // Ex. "ABTestMe-Later" -> "AB Test Me Later"
        let characters = Array(self.characters)
        var result = String(characters[0])
        
        for i in 1 ..< characters.count {
            let currentCharacter = characters[i]
            
            if isSeparator(currentCharacter) {
                continue
            }
            
            // Check previous
            let previousCharacter = characters[i - 1]
            
            if isSeparator(previousCharacter) {
                result.append(" ")
            } else {
                if String(previousCharacter).isUppercase {
                    if String(currentCharacter).isUppercase {
                        let next = i + 1
                        if next < characters.count {
                            let nextCharacter = characters[next]
                            
                            if !isSeparator(nextCharacter) && String(nextCharacter).isLowercase {
                                result.append(" ")
                            }
                        }
                    }
                } else if String(currentCharacter).isUppercase {
                    result.append(" ")
                }
            }
            
            result.append(currentCharacter)
        }
        
        return result
    }
}
