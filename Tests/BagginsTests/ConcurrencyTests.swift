import Baggins
import XCTest

class ConcurrencyTests: XCTestCase {
    func testUnsafeBlocking() throws {
        // Success == Int, Failure == Error
        XCTAssertEqual(
            try Task.unsafeBlocking {
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
        XCTAssertThrowsError(
            try Task.unsafeBlocking {
                try await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
                throw CancellationError()
            }
        )
    }
}
