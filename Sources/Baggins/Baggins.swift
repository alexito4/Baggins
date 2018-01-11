import Foundation


extension Array {
    public func debug() {
        Swift.print(self)
    }
}

extension Bool {
    public func toggled() -> Bool {
        var copy = self
        copy.toggle()
        return copy
    }
    
    public mutating func toggle() {
        self = !self
    }
}


extension Array {
    
    public func shifted(by times: Int = 1) -> Array {
        var copy = self
        copy.shift(by: times)
        return copy
    }
    
    public mutating func shift(by times: Int = 1) {
        guard self.count > 1 else {
            return
        }
        let forward = times > 0
        var pendingTimes = abs(times)
        while pendingTimes > 0 {
            defer { pendingTimes -= 1 }
            
            if forward {
                let l = self.popLast()!
                self.insert(l, at: 0)
            } else {
                let f = self.removeFirst()
                self.append(f)
            }
        }
    }
}

extension Array {
    public  func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}



