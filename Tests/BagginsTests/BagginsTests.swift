@testable import Baggins
import XCTest

class BagginsTests: XCTestCase {
    func testToggle() {
        XCTAssertEqual(true.toggled(), false)
        XCTAssertEqual(false.toggled(), true)
    }

    static var allTests = [
        ("testToggle", testToggle),
    ]
}

class ArrayTests: XCTestCase {
    func testShift() {
        XCTAssertEqual([1, 2, 3].shifted(by: 0), [1, 2, 3])
        XCTAssertEqual([1, 2, 3].shifted(by: 1), [3, 1, 2])
        XCTAssertEqual([1, 2, 3].shifted(by: -1), [2, 3, 1])

        XCTAssertEqual([1, 2, 3].shifted(by: 2), [2, 3, 1])
        XCTAssertEqual([1, 2, 3].shifted(by: 3), [1, 2, 3])
        XCTAssertEqual([1, 2, 3].shifted(by: 4), [3, 1, 2])
    }

    static var allTests = [
        ("testShift", testShift),
    ]
}

class StringTests: XCTestCase {
    func testContains() {
        XCTAssertFalse("some text".contains(anyOf: [] as [String]))
        XCTAssertTrue("some text".contains(anyOf: ["some"]))
        XCTAssertTrue("some text".contains(anyOf: ["some", "text"]))
        XCTAssertTrue("some text".contains(anyOf: ["none", "text"]))
        XCTAssertFalse("some text".contains(anyOf: ["none", "string"]))
    }
}
