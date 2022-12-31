import Foundation

// MARK: - Timeout

public func withTimeout<R>(
    _ seconds: Double,
    _ work: @escaping () async throws -> R
) async throws -> R {
    try await firstOf {
        try await work()
    } or: {
        try? await Task.sleep(seconds: seconds)
        throw TimeoutError()
    }
}

public struct TimeoutError: Error {}

// MARK: - Race

public func firstOf<R>(
    _ f1: @escaping () async throws -> R,
    or f2: @escaping () async throws -> R
) async throws -> R {
    // All the cancellation checks I feel they shouldn't be necessary.
    // But I haven't been able to write a unit test that triggers the guard of
    // `addTaskUnlessCancelled`...
    try Task.checkCancellation()
    return try await withThrowingTaskGroup(of: R.self) { group in
        try Task.checkCancellation()
        guard group.addTaskUnlessCancelled(operation: { try await f1() }) else {
            throw CancellationError()
        }
        guard group.addTaskUnlessCancelled(operation: { try await f2() }) else {
            group.cancelAll()
            throw CancellationError()
        }
        guard let first = try await group.next() else {
            fatalError()
        }
        group.cancelAll()
        return first
    }
}

// MARK: - Sleep

// Hopefully this becomes not necessary when the Clock/Instant/Duration proposal is implemented.
// https://github.com/apple/swift/pull/40609/files#
public extension Task where Success == Never, Failure == Never {
    /// Suspends the current task for at least the given duration
    /// in seconds.
    ///
    /// If the task is canceled before the time ends,
    /// this function throws `CancellationError`.
    ///
    /// This function doesn't block the underlying thread.
    static func sleep(seconds: Double) async throws {
        let nSecPerSec = 1000000000.0 // NSEC_PER_SEC is not available on Linux
        try await sleep(nanoseconds: UInt64(seconds * nSecPerSec))
    }
}

// MARK: - Task.unsafeBlocking

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
