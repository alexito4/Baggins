import Baggins
import XCTest

class BoolTests: XCTestCase {
    func testToggle() {
        XCTAssertEqual(true.toggled(), false)
        XCTAssertEqual(false.toggled(), true)
    }
}
