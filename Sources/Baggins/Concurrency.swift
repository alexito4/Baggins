import AppKit
import Foundation

public extension Task where Failure == Error {
    /// Runs the given throwing operation synchronously
    /// blocking the current thread.
    ///
    /// ⚠️ This is an unsafe operation. The current thread will
    /// be blocked until the given operation completes. It may
    /// deadlock.
    @discardableResult
    @_alwaysEmitIntoClient
    static func unsafeBlocking(
        priority: TaskPriority? = nil,
        @_inheritActorContext @_implicitSelfCapture operation: @Sendable @escaping () async throws -> Success
    ) throws -> Success {
        var result: Result<Success, Error>!
        let onResult = { (r: Result<Success, Error>) in
            result = r
        }
        let semaphore = DispatchSemaphore(value: 0)
        Task<Void, Never>(priority: priority) {
            do {
                let value = try await operation()
                onResult(.success(value))
            } catch {
                onResult(.failure(error))
            }
            semaphore.signal()
        }
        semaphore.wait()
        return try result!.get()
    }
}

public extension Task where Failure == Never {
    /// Runs the given nonthrowing operation synchronously
    /// blocking the current thread.
    ///
    /// ⚠️ This is an unsafe operation. The current thread will
    /// be blocked until the given operation completes. It may
    /// deadlock.
    @discardableResult
    @_alwaysEmitIntoClient
    static func unsafeBlocking(
        priority: TaskPriority? = nil,
        @_inheritActorContext @_implicitSelfCapture operation: @Sendable @escaping () async -> Success
    ) -> Success {
        var result: Success!
        let onResult = { (value: Success) in
            result = value
        }
        let semaphore = DispatchSemaphore(value: 0)
        Task<Void, Never>(priority: priority) {
            let value = await operation()
            onResult(value)
            semaphore.signal()
        }
        semaphore.wait()
        return result!
    }
}
