import Foundation

struct Listing: Decodable, Identifiable, Equatable {
    let id: Int
    let title: String
    let categoryId: Int
    let price: Int
    let imagesUrl: ImagesURL?
    let creationDate: Date
    let isUrgent: Bool
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case categoryId = "category_id"
        case price
        case imagesUrl = "images_url"
        case creationDate = "creation_date"
        case isUrgent = "is_urgent"
        case description
    }
}
