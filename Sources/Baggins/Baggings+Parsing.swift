//
//  Baggings+Parsing.swift
//  GenesisCore
//
//  Created by Alejandro Martinez on 25/11/2017.
//

import Foundation

extension StringProtocol {
    func split(withWord separator: String) -> [String] {
        var res = [String]()
        
        var current = self.startIndex
        var accIndex = current
        
        var ignoreAccumulations = false
        func finishAccumulation(endingAt: Self.Index? = nil) {
            // Handle edge cases
            guard ignoreAccumulations == false else {
                return
            }
            guard current != self.startIndex else {
                current = self.endIndex
                ignoreAccumulations = true
                return
            }
            
            let accEnd = self.index(before: current)
            if accIndex <= accEnd {
                res.append(String(self[accIndex...accEnd]))
            }
            
            // Reset
            if let matchingIndex = endingAt {
                current = matchingIndex
                accIndex = current
            }
        }
        
        while current != self.endIndex {
            var matched = true
            var matchingIndex = current
            for (i, sc) in separator.enumerated() {
                if self[matchingIndex] != sc {
                    matched = false
                    break
                } else {
                    matchingIndex = self.index(after: matchingIndex)
                    // Check if it's going over the end of the separator
                    let isLastSeparatorCharacter = i >= separator.count-1
                    if matchingIndex == self.endIndex && !isLastSeparatorCharacter {
                        matched = false
                        break
                    }
                }
            }
            if matched {
                finishAccumulation(endingAt: matchingIndex)
            } else {
                current = self.index(after: current)
            }
        }
        finishAccumulation()
        
        return res
    }
}
