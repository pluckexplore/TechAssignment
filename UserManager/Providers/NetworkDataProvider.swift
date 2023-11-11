import Foundation

final class NetworkDataProvider {
    static var scheme = "https"
    static var host = "jsonplaceholder.typicode.com"
    
    enum Endpoint: String {
        case users
        var path: String {
            "/\(rawValue)"
        }
    }
    
    static func loadData<T: Decodable>(fromEndpoint endpoint: Endpoint) async throws -> [T] {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = endpoint.path

        guard let url = urlComponents.url else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([T].self, from: data)
    }
}
