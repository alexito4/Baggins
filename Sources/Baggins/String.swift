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

    /// Returns a Boolean value indicating whether the strings contains any
    /// of the other strings provided.
    func contains<S>(anyOf array: S...) -> Bool where S: StringProtocol {
        contains(anyOf: array)
    }

    /// Returns a Boolean value indicating whether the strings contains any
    /// of the other strings provided.
    /// - Note: Overload for Sequence.
    func contains<C: Sequence>(anyOf array: C) -> Bool where C.Element: StringProtocol {
        array.contains(where: contains)
    }
}

public extension StringProtocol {
    /// Splits the String based on the given String.
    /// - Note: Needed because Swift only provides a split based on `Character`.
    func split(withWord separator: String) -> [String] {
        var res = [String]()

        var current = startIndex
        var accIndex = current

        func finishAccumulation(endingAt: Self.Index? = nil) {
            func reset() {
                if let matchingIndex = endingAt {
                    current = matchingIndex
                    accIndex = current
                }
            }
            guard current != accIndex else {
                reset()
                return
            }

            let accEnd = index(before: current)
            if accIndex <= accEnd {
                res.append(String(self[accIndex...accEnd]))
            }

            // Reset
            reset()
        }

        while current != endIndex {
            var matched = true
            var matchingIndex = current
            for (i, sc) in separator.enumerated() {
                if self[matchingIndex] != sc {
                    matched = false
                    break
                } else {
                    matchingIndex = index(after: matchingIndex)
                    // Check if it's going over the end of the separator
                    let isLastSeparatorCharacter = i >= separator.count - 1
                    if matchingIndex == endIndex, !isLastSeparatorCharacter {
                        matched = false
                        break
                    }
                }
            }
            if matched {
                finishAccumulation(endingAt: matchingIndex)
            } else {
                current = index(after: current)
            }
        }
        finishAccumulation()

        return res
    }
}
