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

extension UserStorageProvider: StorageProvider {
    typealias T = User
    
    func save(with attribute: UserData) throws {
        do {
            let user = User(context: childContext)
            user.name = attribute.name
            user.email = attribute.email
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
    
    func exists(with attribute: String) throws -> Bool {
        do {
            let fetchRequest = try UserStorageProviderTask.exists(email: attribute).taskRequest()
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
    
    func delete(with attribute: String) throws {
        do {
            guard let user = try getUser(byEmail: attribute) else {
                throw StorageProviderError.fetchFailed
            }
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

    func getUser(byEmail email: String) throws -> User? {
        do {
            let request = User.fetchRequest() as NSFetchRequest
            request.predicate = NSPredicate(format: "email == %@", email)
            request.fetchLimit = 1
            let user = try context.fetch(request)
            return user.first
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
}

