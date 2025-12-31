import SwiftUI

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel
    
    init(viewModel: CharacterDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                imageHeader
                
                VStack(spacing: 20) {
                    nameAndStatusSection
                    
                    infoGridSection
                    
                    episodesSection
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .offset(y: -20)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: .constant(viewModel.error != nil)) {
            Alert(
                title: Text(AppStrings.CharacterDetail.errorTitle),
                message: Text(viewModel.error ?? AppStrings.CharacterDetail.unknownError),
                dismissButton: .default(Text(AppStrings.CharacterDetail.ok)) {
                    viewModel.error = nil
                }
            )
        }
        .task {
            await viewModel.loadFullDetails()
        }
    }
    
    // MARK: - Subviews
    private var imageHeader: some View {
        AsyncImage(url: URL(string: viewModel.character.image)) { phase in
            switch phase {
                case .success(let image):
                    ZStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .blur(radius: 20)
                            .clipped()
                        
                         image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
                            .cornerRadius(12)
                            .shadow(radius: 10)
                            .padding(.top, 60)
                    }
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 400)
                        .overlay(Image(systemName: "exclamationmark.triangle"))
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 400)
                        .overlay(ProgressView())
                @unknown default:
                    EmptyView()
            }
        }
    }
    
    private var infoGridSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(AppStrings.CharacterDetail.informationTitle)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                InfoCard(icon: "person.fill", title: AppStrings.CharacterDetail.Info.gender, value: viewModel.character.gender.rawValue)
                InfoCard(icon: getSpeciesIcon(viewModel.character.species), title: AppStrings.CharacterDetail.Info.species, value: viewModel.character.species)
                InfoCard(icon: "globe", title: AppStrings.CharacterDetail.Info.origin, value: viewModel.character.origin.name)
                InfoCard(icon: "map.fill", title: AppStrings.CharacterDetail.Info.location, value: viewModel.character.location.name)
            }
            .padding(.horizontal)
        }
    }
    
    private var nameAndStatusSection: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(viewModel.character.name)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack {
                StatusBadge(status: viewModel.character.status)
                
                if !viewModel.character.type.isEmpty {
                    Text(AppStrings.CharacterDetail.separator)
                        .foregroundColor(.secondary)
                    
                    Text(viewModel.character.type)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.top, 10)
    }
    
    private var episodesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()
                .padding(.horizontal)
            
            HStack {
                Text(AppStrings.CharacterDetail.episodesTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Text("\(viewModel.character.episode.count)")
                    .font(.caption)
                    .padding(6)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            
            Text(AppStrings.CharacterDetail.episodesCount(viewModel.character.episode.count))
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
    }
    
    private func getSpeciesIcon(_ species: String) -> String {
        switch species.lowercased() {
        case "human": return "figure.stand"
        default: return "atom"
        }
    }

    struct StatusBadge: View {
        let status: Status
        
        var color: Color {
            switch status {
            case .alive: return .green
            case .dead: return .red
            case .unknown: return .gray
            }
        }
        
        var body: some View {
            HStack(spacing: 4) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                Text(status.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(color)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }

    struct InfoCard: View {
        let icon: String
        let title: String
        let value: String
        
        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue.opacity(0.8))
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    Text(value)
                        .font(.callout)
                        .fontWeight(.medium)
                        .fixedSize(horizontal: false, vertical: true) 
                }
                Spacer()
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
