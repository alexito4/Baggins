//
//  Baggins+Throwing.swift
//  Baggings
//
//  Created by Alejandro Martinez on 25/11/2017.
//

public extension Optional {
    public struct UnwrappingError: Error {
        public let text: String
    }
}

infix operator -?!: AdditionPrecedence
public extension Optional {
    public static func -?! (lhs: Optional<Wrapped>, rhs: String) throws -> Wrapped {
        switch lhs {
        case .some(let value):
            return value
        case .none:
            throw UnwrappingError(text: rhs)
        }
    }
}

postfix operator -?!
public extension Optional {
    public static postfix func -?! (lhs: Optional<Wrapped>) throws -> Wrapped {
        return try lhs -?! "Error unwrapping optional"
    }
}

extension Collection {
    public func element(at index: Index) -> Element? {
        if index < endIndex {
            return self[index]
        } else {
            return nil
        }
    }
}
