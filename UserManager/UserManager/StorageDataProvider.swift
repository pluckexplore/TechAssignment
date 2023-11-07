import Foundation
import CoreData

enum StorageDataProviderError: Error {
    case fetchFailed
    case savingFailed
}

final class StorageDataProvider {

    static let shared: StorageDataProvider = StorageDataProvider()
    
    private let context = CoreDataStack(modelName: "DataModel").managedContext
    
    private lazy var childContext: NSManagedObjectContext = {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = context
        return childContext
    }()
    
    func fetchStoredUsers() throws -> [User] {
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
            let savedUsers = try context.fetch(request)
            return savedUsers
        } catch {
            throw StorageDataProviderError.fetchFailed
        }
    }
    
    func newUser() throws -> User {
        return User(context: childContext)
    }
    
    func saveUser(_ user: User, withName name: String, withEmail email: String) {
        user.name = name
        user.email = email
        do {
            try childContext.save()
            try saveContext()
        } catch {
            debugPrint(error)
        }
    }
    
    func deleteUser(_ user: User) {
        context.delete(user)
        try? saveContext()
    }
    
    func saveContext() throws {
        do {
            try context.save()
        } catch {
            throw StorageDataProviderError.savingFailed
        }
    }
}

