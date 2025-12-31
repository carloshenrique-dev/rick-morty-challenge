import Foundation
import Combine

@MainActor
final class CharacterListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var characters: [Character] = []
    @Published var state: ViewState = .idle
    @Published var searchText: String = ""
    @Published var selectedStatus: Status? = nil
    @Published var isLoadingMore = false
    
    // MARK: - State Enum
    enum ViewState: Equatable {
        case idle
        case loading
        case error(String)
        case empty
    }
    
    // MARK: - Properties
    private let getCharactersUseCase: GetCharactersUseCase
    private var currentPage = 1
    private var canLoadMore = true
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Init
    init(getCharactersUseCase: GetCharactersUseCase) {
        self.getCharactersUseCase = getCharactersUseCase
        
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.searchTask?.cancel()
                self?.searchTask = Task { [weak self] in
                    await self?.resetAndLoad()
                }
            }
            .store(in: &cancellables)
            
        $selectedStatus
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchTask?.cancel()
                self?.searchTask = Task { [weak self] in
                    await self?.resetAndLoad()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    func loadData() async {
        if state == .idle {
            await resetAndLoad()
        }
    }
    
    func resetAndLoad() async {
        currentPage = 1
        canLoadMore = true
        characters = []
        state = .loading
        
        await fetchCharacters()
    }
    
    func loadMore() async {
        guard canLoadMore, !isLoadingMore, state != .loading else { return }
        isLoadingMore = true
        await fetchCharacters()
        isLoadingMore = false
    }
    
    private func fetchCharacters() async {
        if Task.isCancelled { return }
        
        do {
            let result = try await getCharactersUseCase.execute(
                page: currentPage,
                name: searchText.isEmpty ? nil : searchText,
                status: selectedStatus
            )
            
            if result.items.isEmpty {
                if currentPage == 1 {
                    state = .empty
                }
                canLoadMore = false
            } else {
                if currentPage == 1 {
                    characters = result.items
                } else {
                    characters.append(contentsOf: result.items)
                }
                state = .idle
                currentPage += 1
                
                canLoadMore = result.next != nil
            }
            
        } catch {
            if currentPage == 1 {
                state = .error(error.localizedDescription)
            } else {
                canLoadMore = false 
            }
        }
    }
}
