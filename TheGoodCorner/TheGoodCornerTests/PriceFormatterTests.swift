import XCTest
@testable import TheGoodCorner

final class PriceFormatterTests: XCTestCase {

    func testFormatPriceInEuros() {
        let formatter = PriceFormatter(locale: Locale(identifier: "fr_FR"))

        let result = formatter.format(price: 120)

        XCTAssertTrue(result.contains("120"))
        XCTAssertTrue(result.contains("€"))
    }
}
