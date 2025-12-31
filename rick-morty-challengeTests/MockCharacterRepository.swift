import Foundation
@testable import rick_morty_challenge

final class MockCharacterRepository: CharacterRepository {
    var resultToReturn: PaginatedResult<Character>?
    var errorToThrow: Error?
    
    func getCharacters(page: Int, name: String?, status: Status?) async throws -> PaginatedResult<Character> {
        if let error = errorToThrow {
            throw error
        }
        
        return resultToReturn ?? PaginatedResult(items: [], next: nil, prev: nil, count: 0, pages: 0)
    }
    
    func getCharacterDetail(id: Int) async throws -> Character {
        if let error = errorToThrow {
            throw error
        }

        return resultToReturn?.items.first ?? Character(id: 1, name: "Mock", status: .alive, species: "Human", type: "", gender: .male, origin: Origin(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: "")
    }
}
