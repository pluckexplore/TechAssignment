import Foundation
import Combine

struct UserData: Decodable, Hashable {
    let name: String
    let email: String
}

final class UsersEngine {
    
    enum SavingError: Error {
        case alreadyExists
        case databaseError
    }
    
    private let storage: StorageDataProvider
    
    @Published var localUsers: [UserData] = []
    
    init(storage: StorageDataProvider) {
        self.storage = storage
        localUsers = getUsersFromStorage()
    }
}

extension UsersEngine {
    func saveUser(withData userData: UserData) throws -> Result<Void, Error> {
        do {
            guard try storage.checkIfAlreadyExists(userWithEmail: userData.email) else {
                try storage.saveUser(withData: userData)
                localUsers.append(userData)
                return .success(())
            }
            return .failure(SavingError.alreadyExists)
        } catch {
            return .failure(error)
        }
    }
    
    func merge() async throws {
        let remoteUsers = try await getRemoteUsers()
        for userData in remoteUsers {
            _ = try saveUser(withData: userData)
        }
    }
    
    func deleteUser(withEmail email: String) throws {
        localUsers.removeAll { $0.email == email }
        try storage.deleteUser(withEmail: email)
    }
}

private extension UsersEngine {
    func getUsersFromStorage() -> [UserData] {
        do {
            let users = try storage.fetchAllUsers()
            return users.map { UserData(name: $0.name , email: $0.email ) }
        } catch {
            debugPrint(error)
            return []
        }
    }
    
    func getRemoteUsers() async throws -> [UserData] {
        return try await NetworkDataProvider.loadData(fromEndpoint: .users)
    }
}
