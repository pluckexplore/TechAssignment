import Foundation
import Combine

final class UsersEngine {
    
    enum SavingError: Error {
        case alreadyExists
        case databaseError
    }
    
    private let storage: UserStorageProvider
    
    @Published var localUsers: [UserData] = []
    
    init(storage: UserStorageProvider) {
        self.storage = storage
        localUsers = getUsersFromStorage()
    }
}

extension UsersEngine {
    func saveUser(withData userData: UserData) throws -> Result<Void, Error> {
        do {
            guard try storage.exists(with: userData.email) else {
                try storage.save(with: userData)
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
        try storage.delete(with: email)
    }
}

private extension UsersEngine {
    func getUsersFromStorage() -> [UserData] {
        do {
            let users = try storage.fetchAll()
            return users.map { UserData(userObject: $0) }
        } catch {
            debugPrint(error)
            return []
        }
    }
    
    func getRemoteUsers() async throws -> [UserData] {
        return try await NetworkDataProvider.loadData(fromEndpoint: .users)
    }
}
