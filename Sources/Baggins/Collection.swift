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

    /// Wraps the collection in an optional.
    /// If the collection is empty the resulting optional will be `nil`.
    /// From [objc.io](https://www.objc.io/blog/2019/01/29/non-empty-collections/)
    var nonEmpty: Self? {
        isEmpty ? nil : self
    }
}
