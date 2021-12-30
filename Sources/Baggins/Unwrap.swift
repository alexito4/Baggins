import Foundation

// MARK: - unwrap or throw

public extension Optional {
    struct UnwrapError: Error {
        public init() {}
    }
}

// MARK: Coalescing: optional ?? error

/// Throws the error.
///
/// Since `throw` is not an expression you can use this function to throw an error while coalescing an optional.
/// ```
/// try nilWork() ?? raise(YourError())
/// ```
/// - Note: You can raise a fatalError() but you will see a warning. Instead just use the fatalError() without `raise`
public func raise<T>(_ error: Error) throws -> T {
    throw error
}

/// Coalesce the optional to a thrown error.
///
/// This overload allows you to use the error directly without the need of `raise(_:)`
/// ```
/// try nilWork() ?? YourError()
/// ```
@_disfavoredOverload
@inlinable
public func ?? <T, E: Error>(
    value: T?,
    error: @autoclosure () -> E
) throws -> T {
    guard let value = value else { throw error() }
    return value
}

// MARK: Method

public extension Optional {
    /// Returns the unwrapped value or throws the given error.
    ///
    /// You can use `fatalError()` to crash instead of throwing an error.
    /// - See Also: `raise(_:)`
    /// - See Also: `optional ?? YourError()`
    func unwrapOrThrow(
        _ error: @autoclosure () -> Error = UnwrapError()
    ) throws -> Wrapped {
        guard let value = self else { throw error() }
        return value
    }
}

// MARK: - unwrap or die

// Use fatalError("message") with the "unwrap or throw" helpers above to instead crash but with a better message than what force unwrapping provides.

/// This overload won't be needed when `Never` becomes a true bottom type.
@_disfavoredOverload
@inlinable
public func ?? <T>(
    value: T?,
    failure: @autoclosure () -> Never
) -> T {
    guard let value = value else { failure() }
    return value
}

// MARK: -

infix operator -?!: AdditionPrecedence
public extension Optional {
    static func -?! (lhs: Wrapped?, rhs: String) throws -> Wrapped {
        switch lhs {
        case let .some(value):
            return value
        case .none:
            throw UnwrapError() // (text: rhs)
        }
    }
}

postfix operator -?!
public extension Optional {
    static postfix func -?! (lhs: Wrapped?) throws -> Wrapped {
        try lhs -?! "Error unwrapping optional"
    }
}
