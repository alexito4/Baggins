import Foundation
// This file contains candidates to be added to Baggins.

// Exploration to see if a Zip style API is actually more understandable than spread async lets.
/// Still brewing... 🧙‍♂️
public func asyncZip<Left, Right, Return>(
    _ left: () async throws -> Left,
    _ right: () async throws -> Right,
    combined: (Left, Right) async throws -> Return
) async throws -> Return {
    async let leftResult = left()
    async let rightResult = right()
    return try await combined(leftResult, rightResult)
}

/// Still brewing... 🧙‍♂️
/// Needs a math library.
public func ilerp<T: FloatingPoint>(_ t: T, min: T, max: T) -> T {
    (t - min) / (max - min)
}


public extension String {
    /// Still brewing... 🧙‍♂️
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowedCharacterSet = NSMutableCharacterSet.alphanumeric()
        allowedCharacterSet.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)
    }
}

// MARK: Optional

/// Inspired by Rust Option type

extension Optional {
    /// Still brewing... 🧙‍♂️
    var isNone: Bool {
        self == nil
    }
    
    /// Still brewing... 🧙‍♂️
    var isSome: Bool {
        self != nil
    }
}

extension Optional {
    /// Still brewing... 🧙‍♂️
    /// Rust `pub fn expect(self, msg: &str) -> T`
    /// Now we have UnwrapOrThrow library, but I don't really use this so it stayed here.
    func unwrap(orDie message: String) -> Wrapped {
        if let value = self {
            return value
        } else {
            fatalError(message)
        }
    }

    /// Still brewing... 🧙‍♂️
    /// Swift's `??` operator
    /// Rust `pub fn unwrap_or(self, def: T) -> T`
    /// Now we have UnwrapOrThrow library, but I don't really use this so it stayed here.
    func unwrap(or default: Wrapped) -> Wrapped {
        if let value = self {
            return value
        } else {
            return `default`
        }
    }

    /// Still brewing... 🧙‍♂️
    /// Swift's `??` operator
    /// Rust `pub fn unwrap_or_else<F>(self, f: F) -> T`
    /// Now we have UnwrapOrThrow library, but I don't really use this so it stayed here.
    func unwrap(orElse closure: @autoclosure () -> Wrapped) -> Wrapped {
        if let value = self {
            return value
        } else {
            return closure()
        }
    }

    /// Still brewing... 🧙‍♂️
    /// Swift's `??` operator
    /// Rust `pub fn unwrap_or_else<F>(self, f: F) -> T`
    /// Now we have UnwrapOrThrow library, but I don't really use this so it stayed here.
    func unwrap(orElse closure: () -> Wrapped) -> Wrapped {
        if let value = self {
            return value
        } else {
            return closure()
        }
    }
}

/// Still brewing... 🧙‍♂️
// continue with pub fn ok_or<E>(self, err: E) -> Result<T, E> but that will need to conditionally compile only if Result is available, but probably the Result library already has similar functionality?

/// Still brewing... 🧙‍♂️
// This is not part of the UnwrapOrThrow package because I ended up never using it.
// public extension Optional {
//    struct UnwrappingError: Error {
//        public let text: String
//    }
// }
//
// infix operator -?!: AdditionPrecedence
// public extension Optional {
//    static func -?! (lhs: Optional<Wrapped>, rhs: String) throws -> Wrapped {
//        switch lhs {
//        case .some(let value):
//            return value
//        case .none:
//            throw UnwrappingError(text: rhs)
//        }
//    }
// }
//
// postfix operator -?!
// public extension Optional {
//    static postfix func -?! (lhs: Optional<Wrapped>) throws -> Wrapped {
//        return try lhs -?! "Error unwrapping optional"
//    }
// }
