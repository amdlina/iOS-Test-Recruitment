import XCTest
@testable import TheGoodCorner

final class DecodingTests: XCTestCase {

    func testDecodeListingsResponse() throws {
        let json = """
        {
          "items": [
            {
              "id": 1,
              "title": "iphone",
              "category_id": 2,
              "price": 1100,
              "images_url": {
                "small": "/images/1.jpg",
                "thumb": "/images/1.jpg"
              },
              "creation_date": "2024-01-01T10:00:00Z",
              "is_urgent": true,
              "description": "Très bon état",
            }
          ],
          "total": 1,
          "page": 1,
          "limit": 20,
          "has_more": false
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder.goodCornerDecoder.decode(ListingsResponse.self, from: json)

        XCTAssertEqual(response.items.count, 1)
        XCTAssertEqual(response.items[0].title, "iphone")
        XCTAssertEqual(response.items[0].categoryId, 2)
        XCTAssertEqual(response.items[0].imagesUrl?.small, "/images/1.jpg")
        XCTAssertTrue(response.items[0].isUrgent)
        XCTAssertFalse(response.hasMore)
    }

    func testDecodeCategories() throws {
        let json = """
        [
          { "id": 1, "name": "Véhicule" },
          { "id": 2, "name": "Tech" }
        ]
        """.data(using: .utf8)!

        let categories = try JSONDecoder().decode([CategoryItem].self, from: json)

        XCTAssertEqual(categories.count, 2)
        XCTAssertEqual(categories[0].name, "Véhicule")
    }
}
