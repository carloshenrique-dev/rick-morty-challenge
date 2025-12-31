import XCTest
@testable import rick_morty_challenge

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override final class func canInit(with request: URLRequest) -> Bool { return true }
    override final class func canonicalRequest(for request: URLRequest) -> URLRequest { return request }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

@MainActor
final class APIClientTests: XCTestCase {
    var apiClient: APIClient!
    var session: URLSession!
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        apiClient = APIClient(session: session)
    }
    
    func testFetchSuccess() async throws {
        let json = """
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "",
            "gender": "Male",
            "origin": {"name":"Earth", "url":""},
            "location": {"name":"Earth", "url":""},
            "image": "url",
            "episode": [],
            "url": "url",
            "created": "date"
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, json)
        }
        
        let character: CharacterDTO = try await apiClient.fetch("https://test.com")
        
        XCTAssertEqual(character.name, "Rick Sanchez")
    }
    
    func testFetch404Error() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        
        do {
            let _: CharacterDTO = try await apiClient.fetch("https://test.com")
            XCTFail("Should throw error")
        } catch let error as APIError {
            XCTAssertEqual(error.localizedDescription, AppStrings.Network.notFound)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
    
    func testFetchDecodingError() async {
        let invalidJson = "{ \"invalid\": }".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidJson)
        }
        
        do {
            let _: CharacterDTO = try await apiClient.fetch("https://test.com")
            XCTFail("Should throw error")
        } catch let error as APIError {
            XCTAssertEqual(error.localizedDescription, AppStrings.Network.decodingError)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
}
