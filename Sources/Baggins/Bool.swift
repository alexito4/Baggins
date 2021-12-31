import Foundation

public extension Bool {
    /// Non-mutating version of `Bool.toggle()`
    func toggled() -> Bool {
        var copy = self
        copy.toggle()
        return copy
    }
}
