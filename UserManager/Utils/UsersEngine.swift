import Foundation
import Combine

final class UsersEngine {
    
    enum SavingError: Error {
        case alreadyExists
        case databaseError
    }
    
    private let storage: UserStorageDataProvider
    
    @Published var localUsers: [UserData] = []
    
    init(storage: UserStorageDataProvider) {
        self.storage = storage
        localUsers = getUsersFromStorage()
    }
}

extension UsersEngine {
    func saveUser(withData userData: UserData) throws -> Result<Void, Error> {
        do {
            guard try storage.checkIfAlreadyExists(withEmail: userData.email) else {
                try storage.save(withData: userData)
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
        try storage.delete(withEmail: email)
    }
}

private extension UsersEngine {
    func getUsersFromStorage() -> [UserData] {
        do {
            let users = try storage.fetchAll()
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
