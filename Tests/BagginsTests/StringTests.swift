import Baggins
import XCTest

class StringTests: XCTestCase {
    func testLeftPad() throws {
        XCTAssertEqual(
            "1234".leftPadding(to: 5),
            " 1234"
        )
        
        XCTAssertEqual(
            "1234".leftPadding(to: 5, with: "_"),
            "_1234"
        )
        
        XCTAssertEqual(
            "1234".leftPadding(to: 4, with: "_"),
            "1234"
        )
    }
    
    func testIsUppercase() {
        XCTAssertEqual(
            "ABC".isUppercase,
            true
        )
        
        XCTAssertEqual(
            "ABc".isUppercase,
            false
        )
    }
    
    func testIsLowercase() {
        XCTAssertEqual(
            "abc".isLowercase,
            true
        )
        
        XCTAssertEqual(
            "abC".isLowercase,
            false
        )
    }
}
