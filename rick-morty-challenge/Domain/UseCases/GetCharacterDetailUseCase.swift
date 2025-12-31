import Foundation

struct GetCharacterDetailUseCase {
    private let repository: CharacterRepository
    
    init(repository: CharacterRepository) {
        self.repository = repository
    }
    
    /// Executes the use case
    /// - Parameter id: Character ID
    /// - Returns: Character details
    func execute(id: Int) async throws -> Character {
        return try await repository.getCharacterDetail(id: id)
    }
}
