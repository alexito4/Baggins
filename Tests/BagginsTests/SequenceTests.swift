import Baggins
import XCTest

class SequenceTests: XCTestCase {
    func testToArray() throws {
        XCTAssertEqual(
            Set([1, 2, 3])
                .toArray()
                .count,
            3
        )
    }

    func testSorted() throws {
        struct User: Equatable {
            let age: Int
        }
        XCTAssertEqual(
            [User(age: 50), User(age: 78), User(age: 14)].sorted(by: \.age),
            [User(age: 14), User(age: 50), User(age: 78)]
        )
        XCTAssertEqual(
            [User(age: 50), User(age: 78), User(age: 14)].sorted(by: \.age, using: >),
            [User(age: 78), User(age: 50), User(age: 14)]
        )
    }
}
