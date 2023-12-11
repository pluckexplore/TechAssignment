import CoreData

protocol StorageProvider {
    associatedtype T: NSManagedObject
    
    associatedtype SaveTaskAttribute
    associatedtype FetchTaskAttribute
    associatedtype DeleteTaskAttribute
    
    func save(with attribute: SaveTaskAttribute) throws
    func fetch(with attribute: FetchTaskAttribute) throws -> T
    func fetchAll() throws -> [T]
    func delete(with attribute: DeleteTaskAttribute) throws
}

