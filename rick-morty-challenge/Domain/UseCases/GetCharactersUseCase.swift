import Foundation

struct GetCharactersUseCase {
    private let repository: CharacterRepository
    
    init(repository: CharacterRepository) {
        self.repository = repository
    }
    
    /// Executes the use case
    /// - Parameters:
    ///   - page: Page number
    ///   - name: Optional name filter
    ///   - status: Optional status filter
    /// - Returns: Paginated result of characters
    func execute(page: Int, name: String? = nil, status: Status? = nil) async throws -> PaginatedResult<Character> {
        return try await repository.getCharacters(page: page, name: name, status: status)
    }
}
