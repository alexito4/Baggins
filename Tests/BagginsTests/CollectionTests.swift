import Baggins
import XCTest

class CollectionsTests: XCTestCase {
    let array = [2, 4, 8]

    func testOptionalSubscript() throws {
        XCTAssertNil(array[safe: -1])
        XCTAssertNil(array[safe: 3])
        XCTAssertEqual(array[safe: 0], 2)
    }

    func testDefaultSubscript() throws {
        XCTAssertEqual(array[-1, default: 42], 42)
        XCTAssertEqual(array[3, default: 42], 42)
        XCTAssertEqual(array[0, default: 42], 2)
    }
}
