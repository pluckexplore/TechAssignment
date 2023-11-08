import Foundation
import Collections

struct UserData: Decodable, Hashable {
    let name: String
    let email: String
}

final class UserListFetcher {
    
    private let storageDataProvider = StorageDataProvider()
    
    func getRemoteUsers() async throws -> [UserData] {
        return try await NetworkDataProvider.loadData(fromEndpoint: .users)
    }
    
    func getLocalUsers() -> OrderedSet<UserData> {
        do {
            let users = try storageDataProvider.fetchStoredUsers()
            return OrderedSet(users.map { UserData(name: $0.name ?? "", email: $0.email ?? "") })
        } catch {
            debugPrint(error)
            return OrderedSet<UserData>()
        }
    }
}
