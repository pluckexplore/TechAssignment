import Foundation

final class NetworkDataProvider {
    
    private static let baseURL = "https://jsonplaceholder.typicode.com"
    
    enum Endpoint: String {
        case users = "users"
        var dataURL: URL? {
            URL(string: baseURL.appending("/").appending(self.rawValue))
        }
    }
    
    static func loadData<T: Decodable>(fromEndpoint endpoint: Endpoint) async throws -> [T] {
        guard let url = endpoint.dataURL else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([T].self, from: data)
    }
}

