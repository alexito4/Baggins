import Foundation

public extension Sequence {
    /// Convert the Sequence to an Array.
    /// Useful for chaining in fluent syntax methods.
    func toArray() -> [Element] {
        Array(self)
    }
}
