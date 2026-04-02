import Foundation
@testable import ExpiryCue

final class TestClock: Clock {
    var now: Date

    init(now: Date) {
        self.now = now
    }
}
