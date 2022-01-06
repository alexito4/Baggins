import Baggins
import XCTest

class BrewingTests: XCTestCase {
    func testZip() async throws {
        func return10In1s() async throws -> Int {
            try await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
            return 10
        }
        func return20In2s() async throws -> Int {
            try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
            return 20
        }
        let result: Int = try await asyncZip(
            return10In1s,
            return20In2s,
            combined: +
        )
        XCTAssertEqual(result, 30)
    }
}
