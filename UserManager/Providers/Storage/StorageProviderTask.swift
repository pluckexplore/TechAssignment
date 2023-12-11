import CoreData

protocol StorageProviderTask {
    associatedtype T: NSManagedObject
    func taskRequest() throws -> NSFetchRequest<T>
}

