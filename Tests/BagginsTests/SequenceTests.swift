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
}
