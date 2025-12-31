import Foundation

struct AppStrings {
    
    struct Network {
        static let invalidURL = "The URL provided is invalid. Please try again."
        static let connectionError = "A network connection error occurred. Please check your internet connection."
        static let notFound = "No characters found matching your filters."
        static let decodingError = "Failed to process the data from the server. Please try again."
        static let unknownError = "An unknown error occurred. Please try again."
        static func serverError(code: Int) -> String {
            return "The server returned an error (Code: \(code)). Please try again later."
        }
    }
    
    struct CharacterList {
        static let title = "Characters"
        static let searchPrompt = "Search by name"
        static let noCharactersFound = "No characters found."
        static let resetFilters = "Reset Filters"
        static let errorTitle = "Error loading characters"
        static let retry = "Retry"
        static let loadingInitial = "Loading realities..."
        
        struct Filter {
            static let menuLabel = "Filter"
            static let all = "All"
            static let statusTitle = "Status"
        }
    }
    
    struct CharacterDetail {
        static let informationTitle = "Information"
        static let episodesTitle = "Episodes"
        static let errorTitle = "Error"
        static let unknownError = "Unknown error"
        static let ok = "OK"
        static let separator = "•"
        
        struct Info {
            static let gender = "Gender"
            static let species = "Species"
            static let origin = "Origin"
            static let location = "Location"
        }
        
        static func episodesCount(_ count: Int) -> String {
            return "Appears in \(count) episodes throughout the series."
        }
    }
}
