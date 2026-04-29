import Foundation

protocol PriceFormatting {
    func format(price: Int) -> String
}

struct PriceFormatter: PriceFormatting {
    private let formatter: NumberFormatter

    init(locale: Locale = Locale(identifier: "fr_FR")) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = locale
        formatter.maximumFractionDigits = 0
        self.formatter = formatter
    }

    func format(price: Int) -> String {
        formatter.string(from: NSNumber(value: price)) ?? "\(price) €"
    }
}
