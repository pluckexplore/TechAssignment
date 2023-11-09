import Foundation

struct UserData: Decodable, Hashable {
    let name: String
    let email: String
}

final class UserListEngine {
    
    enum SavingError: Error {
        case alreadyExists
        case databaseError
    }
    
    private let storage: StorageDataProvider
    
    init(storage: StorageDataProvider) {
        self.storage = storage
    }
}

extension UserListEngine {
    func getUsersFromStorage() -> [UserData] {
        do {
            let users = try storage.fetchAllUsers()
            return users.map { UserData(name: $0.name ?? "", email: $0.email ?? "") }
        } catch {
            debugPrint(error)
            return []
        }
    }
    
    func merge() async throws {
        let remoteUsers = try await getRemoteUsers()
        for userData in remoteUsers {
            let result = try saveUser(withData: userData)
            switch result {
            case .success:
                continue
            case .failure(let error):
                if case UserListEngine.SavingError.alreadyExists = error {
                    updateUser(withEmail: userData.email)
                }
            }
        }
    }
    
    func updateUser(withEmail email: String) {}
}

private extension UserListEngine {
    func getRemoteUsers() async throws -> [UserData] {
        return try await NetworkDataProvider.loadData(fromEndpoint: .users)
    }
    
    func saveUser(withData userData: UserData) throws -> Result<Void, Error> {
        do {
            guard try storage.checkIfAlreadyExists(userWithEmail: userData.email) else {
                let newUser = try storage.newUser()
                try storage.saveUser(newUser, withName: userData.name, withEmail: userData.email)
                return .success(())
            }
            return .failure(SavingError.alreadyExists)
        } catch {
            return .failure(error)
        }
    }
}
