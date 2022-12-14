import Baggins
import XCTest

func XCTAssertThrowsErrorAsync<T>(
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ error: Error) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
        XCTAssertThrowsError(
            true,
            message(),
            file: file,
            line: line,
            errorHandler
        )
    } catch {
        XCTAssertThrowsError(
            try {
                throw error
            }(),
            message(),
            file: file,
            line: line,
            errorHandler
        )
    }
}

final class TimeTester {
    private let start: CFAbsoluteTime
    init() {
        start = CFAbsoluteTimeGetCurrent()
    }

    func assertElapsed(
        isLessThan target: CFAbsoluteTime,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let diff = CFAbsoluteTimeGetCurrent() - start
        XCTAssertLessThan(diff, target, file: file, line: line)
    }
}

class ConcurrencyTests: XCTestCase {
    // MARK: - Race

    func testRace_Fist() async throws {
        let time = TimeTester()

        let value: Int = try await firstOf {
            try await Task.sleep(seconds: 0.5)
            return 42
        } or: {
            try await Task.sleep(seconds: 1)
            return 99
        }
        XCTAssertEqual(value, 42)

        time.assertElapsed(isLessThan: 1)
    }

    func testRace_Second() async throws {
        let time = TimeTester()

        let value: Int = try await firstOf {
            try await Task.sleep(seconds: 1)
            return 42
        } or: {
            try await Task.sleep(seconds: 0.5)
            return 99
        }
        XCTAssertEqual(value, 99)

        time.assertElapsed(isLessThan: 1)
    }

    func testRace_ImmediatlyCancelle1() async throws {
        let time = TimeTester()

        let task = Task {
            try await firstOf { () -> Int in
                try await Task.sleep(seconds: 1)
                return 42
            } or: {
                try await Task.sleep(seconds: 0.5)
                return 99
            }
        }
        task.cancel()
        await XCTAssertThrowsErrorAsync(try await task.value) { error in
            XCTAssertTrue(error is CancellationError, "Error is CancellationError")
        }

        time.assertElapsed(isLessThan: 0.2)
    }

    func testRace_ImmediatlyCancelle2() async throws {
        let time = TimeTester()

        let task = Task {
            try await firstOf { () -> Int in
                try await Task.sleep(seconds: 1)
                return 42
            } or: {
                try await Task.sleep(seconds: 0.5)
                return 99
            }
        }
        Task {
            task.cancel()
        }
        await XCTAssertThrowsErrorAsync(try await task.value) { error in
            XCTAssertTrue(error is CancellationError, "Error is CancellationError")
        }
        time.assertElapsed(isLessThan: 0.2)
    }

    func testRace_Cancel() async throws {
        let time = TimeTester()

        let task = Task {
            try await firstOf { () -> Int in
                try await Task.sleep(seconds: 1.5)
                return 42
            } or: {
                try await Task.sleep(seconds: 2)
                return 99
            }
        }
        Task {
            try? await Task.sleep(seconds: 1)
            task.cancel()
        }
        await XCTAssertThrowsErrorAsync(try await task.value) { error in
            XCTAssertTrue(error is CancellationError, "Error is CancellationError")
        }
        time.assertElapsed(isLessThan: 1.2)
    }

    // MARK: - Timeout

    func testTimeout_TimesOut() async throws {
        let time = TimeTester()
        await XCTAssertThrowsErrorAsync(try await withTimeout(1) { () -> Int in
            try await Task.sleep(seconds: 2)
            return 42
        }) { error in
            XCTAssertTrue(error is TimeoutError)
        }
        time.assertElapsed(isLessThan: 1.1)
    }

    func testTimeout_Cancelled() async throws {
        let time = TimeTester()
        let task = Task {
            try await withTimeout(2) { () -> Int in
                try await Task.sleep(seconds: 3)
                return 42
            }
        }
        Task {
            try? await Task.sleep(seconds: 1)
            task.cancel()
        }
        await XCTAssertThrowsErrorAsync(try await task.value) { error in
            XCTAssertTrue(error is CancellationError)
        }
        time.assertElapsed(isLessThan: 1.1)
    }

    func testTimeout_InmediatlyCancelled() async throws {
        let time = TimeTester()
        let task = Task {
            try await withTimeout(1) { () -> Int in
                try await Task.sleep(seconds: 2)
                return 42
            }
        }
        task.cancel()
        await XCTAssertThrowsErrorAsync(try await task.value) { error in
            XCTAssertTrue(error is CancellationError)
        }
        time.assertElapsed(isLessThan: 1.1)
    }

    // MARK: - Sleep

    func testSleepSeconds_Cancelled() throws {
        let expectation = expectation(description: "Task completed")
        let task = Task {
            try? await Task.sleep(seconds: 1.5)
            if !Task.isCancelled {
                XCTFail("Task should not have been cancelled.")
            }
            expectation.fulfill()
        }
        Task {
            try? await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
            task.cancel()
        }
        waitForExpectations(timeout: 2)
    }

    func testSleepSeconds_Finishes() throws {
        let expectation = expectation(description: "Task completed")
        let task = Task {
            try? await Task.sleep(seconds: 1.5)
            if Task.isCancelled {
                XCTFail("Task should have been cancelled.")
            }
            expectation.fulfill()
        }
        Task {
            try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
            task.cancel()
        }
        waitForExpectations(timeout: 2.5)
    }
}
