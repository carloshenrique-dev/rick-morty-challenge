import Foundation

protocol CharacterRepository {
    /// Fetches a list of characters with optional pagination and filtering
    /// - Parameters:
    ///   - page: The page number to fetch
    ///   - name: Optional name filter (case-insensitive)
    ///   - status: Optional status filter
    /// - Returns: A paginated result containing characters and page info
    func getCharacters(page: Int, name: String?, status: Status?) async throws -> PaginatedResult<Character>
    
    /// Fetches details for a specific character
    /// - Parameter id: The unique identifier of the character
    /// - Returns: The character details
    func getCharacterDetail(id: Int) async throws -> Character
}
