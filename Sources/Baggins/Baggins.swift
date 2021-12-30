import Foundation

public extension Array {
    func debug() {
        Swift.print(self)
    }
}

public extension Bool {
    func toggled() -> Bool {
        var copy = self
        copy.toggle()
        return copy
    }

    mutating func toggle() {
        self = !self
    }
}

public extension Array {
    func shifted(by times: Int = 1) -> Array {
        var copy = self
        copy.shift(by: times)
        return copy
    }

    mutating func shift(by times: Int = 1) {
        guard count > 1 else {
            return
        }
        let forward = times > 0
        var pendingTimes = abs(times)
        while pendingTimes > 0 {
            defer { pendingTimes -= 1 }

            if forward {
                let l = popLast()!
                insert(l, at: 0)
            } else {
                let f = removeFirst()
                append(f)
            }
        }
    }
}

public extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        stride(from: 0, to: count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

public extension String {
    func contains<C: Sequence>(anyOf array: C) -> Bool where C.Element: StringProtocol {
        array.contains(where: { self.contains($0) })
    }
}
