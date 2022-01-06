import Baggins
import XCTest

class ConcurrencyUnsafeBlockingTests: XCTestCase {
    func testUnsafeBlocking() throws {
        // Success == Int, Failure == Error
        let expectation = expectation(description: "All unsafeBlocking finished.")
        let queue = DispatchQueue(label: "test.unsafeBlocking")
        queue.async {
            XCTAssertEqual(
                try? Task.unsafeBlocking {
                    try await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
                    return 42
                },
                42
            )
            // Success == Int, Failure == Never
            XCTAssertEqual(
                Task.unsafeBlocking {
                    try? await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
                    return 42
                },
                42
            )
            // Success == Void, Failure == Error
            do {
                XCTAssertThrowsError(
                    try Task.unsafeBlocking {
                        try await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
                        throw CancellationError()
                    }
                )
            } catch {}
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
}
