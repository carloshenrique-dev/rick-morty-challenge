import SwiftUI

struct CharacterListView<DetailView: View>: View {
    @StateObject private var viewModel: CharacterListViewModel
    private let makeDetailView: (Character) -> DetailView
    
    init(viewModel: CharacterListViewModel, @ViewBuilder makeDetailView: @escaping (Character) -> DetailView) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeDetailView = makeDetailView
    }
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading:
                     if viewModel.characters.isEmpty {
                         VStack {
                             Spacer()
                             PortalLoadingView()
                             Text(AppStrings.CharacterList.loadingInitial)
                                 .font(.subheadline)
                                 .foregroundColor(.secondary)
                                 .padding(.top, 8)
                             Spacer()
                         }
                     } else {
                        listContent
                     }
                    
                case .idle:
                    listContent
                    
                case .empty:
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .padding()
                        Text(AppStrings.CharacterList.noCharactersFound)
                            .foregroundColor(.secondary)
                        Button(AppStrings.CharacterList.resetFilters) {
                            viewModel.searchText = ""
                            viewModel.selectedStatus = nil
                        }
                        .padding()
                    }
                    
                case .error(let message):
                    VStack {
                        PortalLoadingView()
                            .padding(.vertical)
                        Text(AppStrings.CharacterList.errorTitle)
                            .font(.headline)
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(AppStrings.CharacterList.retry) {
                            Task { await viewModel.resetAndLoad() }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
            }
            .navigationTitle(AppStrings.CharacterList.title)
            .searchable(text: $viewModel.searchText, prompt: AppStrings.CharacterList.searchPrompt)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker(AppStrings.CharacterList.Filter.statusTitle, selection: $viewModel.selectedStatus) {
                            Text(AppStrings.CharacterList.Filter.all).tag(Status?.none)
                            ForEach(Status.allCases, id: \.self) { status in
                                Text(status.displayName).tag(Status?.some(status))
                            }
                        }
                    } label: {
                        Label(AppStrings.CharacterList.Filter.menuLabel, systemImage: "line.3.horizontal.decrease.circle")
                            .symbolVariant(viewModel.selectedStatus != nil ? .fill : .none)
                    }
                }
            }
            .task {
                await viewModel.loadData()
            }
        }
    }
    
    private var listContent: some View {
        List {
            ForEach(viewModel.characters) { character in
                NavigationLink(destination: makeDetailView(character)) {
                    CharacterCell(character: character)
                        .onAppear {
                            if character == viewModel.characters.last {
                                Task { await viewModel.loadMore() }
                            }
                        }
                }
            }
            
            if viewModel.isLoadingMore {
                 HStack {
                     Spacer()
                     PortalLoadingView()
                     Spacer()
                 }
                 .padding()
            }
        }
        .listStyle(.plain)
    }
}
