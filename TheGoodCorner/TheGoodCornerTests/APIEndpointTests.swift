import XCTest
@testable import TheGoodCorner

final class APIEndpointTests: XCTestCase {

    func testListingsEndpointWithoutParametersBuildsExpectedURL() throws {
        let request = try APIEndpoint.listings().urlRequest(baseURL: URL(string: "http://localhost:8080")!)

        XCTAssertEqual(request.url?.absoluteString, "http://localhost:8080/listings")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
    }

    func testListingsEndpointWithSearchBuildsEncodedQuery() throws {
        let request = try APIEndpoint.listings(page: nil, limit: nil, query: "iphone 17")
            .urlRequest(baseURL: URL(string: "http://localhost:8080")!)

        XCTAssertTrue(request.url?.absoluteString.contains("query=iphone%2017") == true)
    }

    func testCategoriesEndpointBuildsExpectedURL() throws {
        let request = try APIEndpoint.categories.urlRequest(baseURL: URL(string: "http://localhost:8080")!)

        XCTAssertEqual(request.url?.absoluteString, "http://localhost:8080/categories")
    }
}
