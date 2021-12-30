import Foundation

public extension Collection {
    /// Safe subscript.
    /// It doesn't crash if the index is out of bounds.
    /// Instead it returns nil.
    subscript(safe index: Index) -> Element? {
        guard index >= startIndex, index < endIndex else {
            return nil
        }

        return self[index]
    }

    /// Safe subscript.
    /// It doesn't crash if the index is out of bounds.
    /// Instead it returns the default value.
    subscript(index: Index, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= startIndex, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}
