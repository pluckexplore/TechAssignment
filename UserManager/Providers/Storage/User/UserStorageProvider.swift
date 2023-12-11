import Foundation
import CoreData

class UserStorageProvider {
    private let context: NSManagedObjectContext
    private lazy var childContext: NSManagedObjectContext = {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = context
        return childContext
    }()
    
    init (coreDataStack: CoreDataStack) {
        self.context = coreDataStack.managedContext
    }
}

extension UserStorageProvider {
    func exists(with email: String) throws -> Bool {
        do {
            let fetchRequest = try UserStorageProviderTask.fetchWithEmail(email).taskRequest()
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
}

extension UserStorageProvider: StorageProvider {
    
    typealias T = User
    
    typealias SaveTaskAttributes = UserData
    typealias FetchTaskAttribute = String
    typealias DeleteTaskAttribute = String
    
    func save(with data: UserData) throws {
        do {
            let user = User(context: childContext)
            user.name = data.name
            user.email = data.email
            try childContext.save()
            try saveContext()
        } catch {
            throw StorageProviderError.savingFailed
        }
    }
    
    func fetchAll() throws -> [User] {
        do {
            let fetchRequest = try UserStorageProviderTask.fetchAll.taskRequest()
            let users = try context.fetch(fetchRequest)
            return users
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
    
    func fetch(with email: String) throws -> User {
        do {
            let fetchRequest = try UserStorageProviderTask.fetchWithEmail(email).taskRequest()
            guard let user = try context.fetch(fetchRequest).first else {
                throw StorageProviderError.fetchFailed
            }
            return user
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
    
    func delete(with email: String) throws {
        do {
            let user = try fetch(with: email)
            context.delete(user)
            try saveContext()
        } catch {
            throw StorageProviderError.deletingFailed
        }
    }
}

private extension UserStorageProvider {
    func saveContext() throws {
        do {
            try context.save()
        } catch {
            throw StorageProviderError.savingFailed
        }
    }
}

