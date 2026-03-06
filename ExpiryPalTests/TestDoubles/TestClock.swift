import Foundation
@testable import ExpiryPal

struct TestClock: Clock {
    let now: Date
}
