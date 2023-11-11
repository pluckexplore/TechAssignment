import Foundation
import CoreData

final class StorageDataProvider {
    
    enum DataError: Error {
        case fetchFailed
        case savingFailed
        case deletingFailed
    }
    
    private static let modelName = "DataModel"
    
    private let context = CoreDataStack(modelName: StorageDataProvider.modelName).managedContext
    
    private lazy var childContext: NSManagedObjectContext = {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = context
        return childContext
    }()
}

extension StorageDataProvider {
    func fetchAllUsers() throws -> [User] {
        do {
            let request = User.fetchRequest() as NSFetchRequest
            let compareSelector = #selector(NSString.localizedStandardCompare(_:))
            request.sortDescriptors = [
                NSSortDescriptor(
                    key: #keyPath(User.name),
                    ascending: true,
                    selector: compareSelector
                )
            ]
            let users = try context.fetch(request)
            return users
        } catch {
            throw DataError.fetchFailed
        }
    }
    
    func checkIfAlreadyExists(userWithEmail email: String) throws -> Bool {
        do {
            let request = User.fetchRequest() as NSFetchRequest
            request.predicate = NSPredicate(format: "email == %@", email)
            request.fetchLimit = 1
            let count = try context.count(for: request)
            return count > 0
        } catch {
            throw DataError.fetchFailed
        }
    }
    
    func saveUser(withData data: UserData) throws {
        do {
            let user = User(context: childContext)
            user.name = data.name
            user.email = data.email
            try childContext.save()
            try saveContext()
        } catch {
            throw DataError.savingFailed
        }
    }
    
    func deleteUser(withEmail email: String) throws {
        do {
            guard let user = try getUser(byEmail: email) else {
                throw DataError.fetchFailed
            }
            context.delete(user)
            try saveContext()
        } catch {
            throw DataError.deletingFailed
        }
    }
}

private extension StorageDataProvider {
    func saveContext() throws {
        do {
            try context.save()
        } catch {
            throw DataError.savingFailed
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
            throw DataError.fetchFailed
        }
    }
}
