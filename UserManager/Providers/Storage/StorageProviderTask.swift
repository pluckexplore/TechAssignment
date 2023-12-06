import CoreData

protocol StorageProviderTask<T> {
    associatedtype T: NSManagedObject
    func taskRequest() throws -> NSFetchRequest<T>
}

