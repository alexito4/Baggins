//
//  File.swift
//  
//
//  Created by Alejandro Martinez on 30/12/21.
//

import Foundation

public extension String {
    /// Left pad the string with the given character (space by default).
    func leftPadding(to length: Int, with character: Character = " ") -> String {
        if count >= length {
            return self
        } else {
            let pad = String(repeating: character, count: length - count)
            return "\(pad)\(self)"
        }
    }

    /// Checks if the entire String is uppercase.
    var isUppercase: Bool {
        first(where: \.isLowercase) == nil
    }

    /// Checks if the entire String is lowercase.
    var isLowercase: Bool {
        first(where: \.isUppercase) == nil
    }
}
