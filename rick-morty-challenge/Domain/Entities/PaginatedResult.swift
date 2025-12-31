import Foundation

struct PaginatedResult<T: Codable>: Codable {
    let items: [T]
    let next: String?
    let prev: String?
    let count: Int
    let pages: Int
}
