import SwiftUI

struct ContentView: View {
    var body: some View {
        let apiClient = APIClient()
        let repository = CharacterRepositoryImpl(apiClient: apiClient)
        let getCharactersUseCase = GetCharactersUseCase(repository: repository)
        let viewModel = CharacterListViewModel(getCharactersUseCase: getCharactersUseCase)
        
        let categoryDetailUseCase = GetCharacterDetailUseCase(repository: repository)
        
        CharacterListView(viewModel: viewModel) { character in
            CharacterDetailView(viewModel: CharacterDetailViewModel(
                getCharacterDetailUseCase: categoryDetailUseCase,
                characterId: character.id,
                initialCharacter: character
            ))
        }
    }
}

#Preview {
    ContentView()
}
