import Foundation
import Combine

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var character: Character
    @Published var isLoading = false
    @Published var error: String?
    
    // MARK: - Properties
    private let getCharacterDetailUseCase: GetCharacterDetailUseCase
    private let characterId: Int
    
    init(getCharacterDetailUseCase: GetCharacterDetailUseCase, characterId: Int, initialCharacter: Character) {
        self.getCharacterDetailUseCase = getCharacterDetailUseCase
        self.characterId = characterId
        self.character = initialCharacter
    }
    
    func loadFullDetails() async {
        isLoading = true
        do {
            let detail = try await getCharacterDetailUseCase.execute(id: characterId)
            self.character = detail
            isLoading = false
        } catch {
            self.error = error.localizedDescription
            isLoading = false
        }
    }
}
