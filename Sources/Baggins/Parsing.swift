import Foundation

public extension StringProtocol {
    @available(*, deprecated, message: "This is probably not needed anymore.")
    func split(withWord separator: String) -> [String] {
        var res = [String]()

        var current = startIndex
        var accIndex = current

        var ignoreAccumulations = false
        func finishAccumulation(endingAt: Self.Index? = nil) {
            // Handle edge cases
            guard ignoreAccumulations == false else {
                return
            }
            guard current != startIndex else {
                current = endIndex
                ignoreAccumulations = true
                return
            }

            let accEnd = index(before: current)
            if accIndex <= accEnd {
                res.append(String(self[accIndex...accEnd]))
            }

            // Reset
            if let matchingIndex = endingAt {
                current = matchingIndex
                accIndex = current
            }
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
