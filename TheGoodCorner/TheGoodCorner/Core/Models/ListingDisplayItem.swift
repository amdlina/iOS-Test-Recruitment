import Foundation

struct ListingDisplayItem: Identifiable, Equatable {
    let listing: Listing
    let categoryName: String
    let formattedPrice: String
    let imageURL: URL?

    var id: Int { listing.id }
    var title: String { listing.title }
    var isUrgent: Bool { listing.isUrgent }
    var description: String? { listing.description }
    var creationDate: Date { listing.creationDate }
}
