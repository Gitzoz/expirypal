import Foundation
@testable import ExpiryPal

final class TestClock: Clock {
    var now: Date

    init(now: Date) {
        self.now = now
    }
}
