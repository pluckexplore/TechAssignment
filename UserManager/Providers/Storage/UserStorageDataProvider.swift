import Foundation
import CoreData

class UserStorageDataProvider {
    
    enum DataError: Error {
        case fetchFailed
        case savingFailed
        case deletingFailed
    }
    
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

extension UserStorageDataProvider {
    func fetchAll() throws -> [User] {
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
    
    func checkIfAlreadyExists(withEmail email: String) throws -> Bool {
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
    
    func save(withData data: UserData) throws {
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
    
    func delete(withEmail email: String) throws {
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

private extension UserStorageDataProvider {
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
