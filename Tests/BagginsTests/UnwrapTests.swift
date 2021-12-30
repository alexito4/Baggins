import Baggins
import XCTest

class UnwrapTests: XCTestCase {
    // MARK: - unwrap or throw

    func testCoalesceWithRaise() throws {
        XCTAssertEqual(
            try someWork() ?? raise(Ups()),
            42
        )

        XCTAssertThrowsError(
            try nilWork() ?? raise(Ups())
        )
    }

    func testCoalesceWithError() throws {
        XCTAssertEqual(
            try someWork() ?? Ups(),
            42
        )

        XCTAssertThrowsError(
            try nilWork() ?? Ups()
        )
    }

    func testUnwrapOrThrow() throws {
        XCTAssertEqual(
            try someWork().unwrapOrThrow(Ups()),
            42
        )

        XCTAssertThrowsError(
            try nilWork().unwrapOrThrow(Ups())
        )
    }

    func testUnwrapOrThrowDefault() throws {
        XCTAssertEqual(
            try someWork().unwrapOrThrow(),
            42
        )

        XCTAssertThrowsError(
            try nilWork().unwrapOrThrow()
        )
    }

    // MARK: - unwrap or die

    func testCoalesceWithRaiseFatalError() throws {
        XCTAssertEqual(
            try someWork() ?? raise(fatalError("ups")),
            42
        )

        XCTAssertFatalError(
            try nilWork() ?? raise(fatalError("ups")),
            "ups"
        )
    }

    func testCoalesceWithFatalError() throws {
        XCTAssertEqual(
            someWork() ?? fatalError("ups"),
            42
        )

        XCTAssertFatalError(
            nilWork() ?? fatalError("ups"),
            "ups"
        )
    }

    func testUnwrapOrThrowFatalError() throws {
        XCTAssertEqual(
            try someWork().unwrapOrThrow(fatalError("ups")),
            42
        )

        XCTAssertFatalError(
            try nilWork().unwrapOrThrow(fatalError("ups")),
            "ups"
        )
    }
}

private struct Ups: Error {}

private func someWork() -> Int? {
    42
}

private func nilWork() -> Int? {
    nil
}

// MARK: -

extension XCTestCase {
    func XCTAssertFatalError<T>(
        _ testcase: @autoclosure @escaping () throws -> T,
        _ expectedMessage: String
    ) {
        // arrange
        let expectation = expectation(description: "expectingFatalError")
        var assertionMessage: String?

        // override fatalError. This will pause forever when fatalError is called.
        FatalErrorUtil.replaceFatalError { message, _, _ in
            assertionMessage = message
            expectation.fulfill()
            unreachable()
        }

        // act, perform on separate thead because a call to fatalError pauses forever
        DispatchQueue.global(qos: .userInitiated).async {
            _ = try? testcase()
        }

        waitForExpectations(timeout: 0.1) { _ in
            // assert
            XCTAssertEqual(assertionMessage, expectedMessage)

            // clean up
            FatalErrorUtil.restoreFatalError()
        }
    }
}

// overrides Swift global `fatalError`
public func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    FatalErrorUtil.fatalErrorClosure(message(), file, line)
}

/// This is a `noreturn` function that pauses forever
public func unreachable() -> Never {
    repeat {
        RunLoop.current.run()
    } while true
}

/// Utility functions that can replace and restore the `fatalError` global function.
public enum FatalErrorUtil {
    // Called by the custom implementation of `fatalError`.
    static var fatalErrorClosure: (String, StaticString, UInt) -> Never = defaultFatalErrorClosure

    // backup of the original Swift `fatalError`
    private static let defaultFatalErrorClosure = { Swift.fatalError($0, file: $1, line: $2) }

    /// Replace the `fatalError` global function with something else.
    public static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> Never) {
        fatalErrorClosure = closure
    }

    /// Restore the `fatalError` global function back to the original Swift implementation
    public static func restoreFatalError() {
        fatalErrorClosure = defaultFatalErrorClosure
    }
}
