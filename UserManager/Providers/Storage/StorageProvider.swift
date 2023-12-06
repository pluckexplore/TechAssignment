import CoreData

protocol StorageProvider {
    associatedtype T: NSManagedObject
    func save(with attribute: UserData) throws //TODO
    func fetchAll() throws -> [T]
    func exists(with attribute: String) throws -> Bool //TODO
    func delete(with attribute: String) throws //TODO
}

