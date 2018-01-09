//
//  Baggins+Throwing.swift
//  GenesisCore
//
//  Created by Alejandro Martinez on 25/11/2017.
//

extension Optional {
    struct UnwrappingError: Error {
        let text: String
    }
}

infix operator -?!: AdditionPrecedence
extension Optional {
    static func -?! (lhs: Optional<Wrapped>, rhs: String) throws -> Wrapped {
        switch lhs {
        case .some(let value):
            return value
        case .none:
            throw UnwrappingError(text: rhs)
        }
    }
}

postfix operator -?!
extension Optional {
    static postfix func -?! (lhs: Optional<Wrapped>) throws -> Wrapped {
        return try lhs -?! "Error unwrapping optional"
    }
}

extension Collection {
    func element(at index: Index) -> Element? {
        if index < endIndex {
            return self[index]
        } else {
            return nil
        }
    }
}
