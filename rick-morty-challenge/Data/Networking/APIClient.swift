import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case requestFailed(Int)
    case decodingError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return AppStrings.Network.invalidURL
        case .networkError(let error):
            return "\(AppStrings.Network.connectionError) (\(error.localizedDescription))"
        case .requestFailed(let statusCode):
            if statusCode == 404 {
                return AppStrings.Network.notFound
            }
            return AppStrings.Network.serverError(code: statusCode)
        case .decodingError:
            return AppStrings.Network.decodingError
        case .unknown:
            return AppStrings.Network.unknownError
        }
    }
}

final class APIClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Fetches and decodes data from a URL
    /// - Parameters:
    ///   - urlString: The URL string
    ///   - queryItems: Optional query parameters
    /// - Returns: Decoded Type T
    func fetch<T: Decodable>(_ urlString: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        guard var urlComponents = URLComponents(string: urlString) else {
            throw APIError.invalidURL
        }
        
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.requestFailed(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
}
