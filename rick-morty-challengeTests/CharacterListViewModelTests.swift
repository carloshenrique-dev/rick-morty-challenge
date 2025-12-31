import XCTest
import Combine
@testable import rick_morty_challenge

@MainActor
final class CharacterListViewModelTests: XCTestCase {
    var viewModel: CharacterListViewModel!
    var mockRepository: MockCharacterRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCharacterRepository()
        let useCase = GetCharactersUseCase(repository: mockRepository)
        viewModel = CharacterListViewModel(getCharactersUseCase: useCase)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    private func createMockCharacter(id: Int, name: String) -> Character {
        return Character(id: id, name: name, status: .alive, species: "Human", type: "", gender: .male, origin: Origin(name: "Earth", url: ""), location: Location(name: "Earth", url: ""), image: "", episode: [], url: "", created: "")
    }
    
    func testLoadDataSuccess() async {
        let expectedCharacters = [createMockCharacter(id: 1, name: "Rick")]
        let result = PaginatedResult(items: expectedCharacters, next: "next_url", prev: nil, count: 1, pages: 2)
        mockRepository.resultToReturn = result
        
        await viewModel.loadData()
        
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(viewModel.characters.first?.name, "Rick")
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    func testSearchTrigger() async {
        let expectedCharacters = [createMockCharacter(id: 2, name: "Morty")]
        let result = PaginatedResult(items: expectedCharacters, next: nil, prev: nil, count: 1, pages: 1)
        mockRepository.resultToReturn = result
        
        viewModel.searchText = "Morty"
        await viewModel.resetAndLoad()
        
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(viewModel.characters.first?.name, "Morty")
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    func testPagination() async {
        let page1 = [createMockCharacter(id: 1, name: "Rick")]
        mockRepository.resultToReturn = PaginatedResult(items: page1, next: "page2", prev: nil, count: 2, pages: 2)
        
        await viewModel.loadData()
        XCTAssertEqual(viewModel.characters.count, 1)
        
        let page2 = [createMockCharacter(id: 2, name: "Morty")]
        mockRepository.resultToReturn = PaginatedResult(items: page2, next: nil, prev: "page1", count: 2, pages: 2)
        
        await viewModel.loadMore()
        
        XCTAssertEqual(viewModel.characters.count, 2)
        XCTAssertEqual(viewModel.characters[1].name, "Morty")
    }
    
    func testErrorState() async {
        mockRepository.errorToThrow = APIError.networkError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet"]))
        
        await viewModel.loadData()
        
        if case .error(let message) = viewModel.state {
            XCTAssertTrue(message.contains(AppStrings.Network.connectionError))
        } else {
            XCTAssertTrue(false, "State should be error")
        }
    }
    
    func testEmptyState() async {
        mockRepository.resultToReturn = PaginatedResult(items: [], next: nil, prev: nil, count: 0, pages: 0)
        
        await viewModel.loadData()
        
        XCTAssertEqual(viewModel.state, .empty)
        XCTAssertTrue(viewModel.characters.isEmpty)
    }
}
