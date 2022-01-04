import Foundation

public extension Sequence {
    /// Convert the Sequence to an Array.
    /// Useful for chaining in fluent syntax methods.
    func toArray() -> [Element] {
        Array(self)
    }
}

// MARK: Sorting

public extension Sequence {
    /// Returns the elements of the sequence, sorted using the given keypath as
    /// the comparison between elements.
    ///
    /// When you want to sort a sequence of elements that don't conform to the
    /// `Comparable` protocol, pass a predicate to this method that returns
    /// `true` when the first element should be ordered before the second. The
    /// elements of the resulting array are ordered according to the given
    /// predicate.
    func sorted<Value>(
        by keyPath: KeyPath<Self.Element, Value>,
        using valuesAreInIncreasingOrder: (Value, Value) throws -> Bool
    ) rethrows -> [Self.Element] {
        try sorted(by: {
            try valuesAreInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        })
    }

    /// Returns the elements of the sequence, sorted using the given keypath as
    /// the comparison between elements.
    func sorted<Value: Comparable>(
        by keyPath: KeyPath<Self.Element, Value>
    ) -> [Self.Element] {
        sorted(by: keyPath, using: <)
    }
}
