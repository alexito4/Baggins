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

    func testContainsAnyOf() {
        XCTAssertFalse("some text".contains(anyOf: [] as [String]))
        XCTAssertTrue("some text".contains(anyOf: ["some"]))
        XCTAssertTrue("some text".contains(anyOf: ["some", "text"]))
        XCTAssertTrue("some text".contains(anyOf: ["none", "text"]))
        XCTAssertFalse("some text".contains(anyOf: ["none", "string"]))

        XCTAssertTrue("some text".contains(anyOf: "some"))
        XCTAssertTrue("some text".contains(anyOf: "some", "text"))
        XCTAssertTrue("some text".contains(anyOf: "none", "text"))
        XCTAssertFalse("some text".contains(anyOf: "none", "string"))
    }

    func testSplitWithWord() {
        XCTAssertEqual(
            "one two three".split(withWord: "two"),
            ["one ", " three"]
        )
        XCTAssertEqual(
            "one three".split(withWord: "two"),
            ["one three"]
        )
        XCTAssertEqual(
            "one two".split(withWord: "two"),
            ["one "]
        )
        XCTAssertEqual(
            "two three".split(withWord: "two"),
            [" three"]
        )
        XCTAssertEqual(
            "two".split(withWord: "two"),
            []
        )
        XCTAssertEqual(
            "one two three".split(withWord: "to"),
            ["one two three"]
        )
    }
}
