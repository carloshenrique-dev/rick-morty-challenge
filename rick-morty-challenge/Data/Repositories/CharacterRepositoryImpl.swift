import Foundation

final class CharacterRepositoryImpl: CharacterRepository {
    private let apiClient: APIClient
    private let baseURL = "https://rickandmortyapi.com/api/character"
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getCharacters(page: Int, name: String?, status: Status?) async throws -> PaginatedResult<Character> {
        var queryItems = [URLQueryItem(name: "page", value: String(page))]
        
        if let name = name, !name.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: name))
        }
        
        if let status = status {
            queryItems.append(URLQueryItem(name: "status", value: status.rawValue.lowercased()))
        }
        
        let responseDTO: CharacterListResponseDTO = try await apiClient.fetch(baseURL, queryItems: queryItems)
        
        return PaginatedResult(
            items: responseDTO.results.map { $0.toDomain() },
            next: responseDTO.info.next,
            prev: responseDTO.info.prev,
            count: responseDTO.info.count,
            pages: responseDTO.info.pages
        )
    }
    
    func getCharacterDetail(id: Int) async throws -> Character {
        let url = "\(baseURL)/\(id)"
        let dto: CharacterDTO = try await apiClient.fetch(url)
        return dto.toDomain()
    }
}
