import CoreData

enum FetchRequestBuilder {
    struct Parameters {
        var predicate: NSPredicate? = nil
        var fetchLimit: Int? = nil
        var sortDescriptors: [NSSortDescriptor]? = nil
    }
    
    static func build<T: NSManagedObject>(parameters: Parameters) throws -> NSFetchRequest<T> {
        guard let request = T.fetchRequest() as? NSFetchRequest<T> else {
            throw StorageProviderError.fetchFailed
        }
        if let fetchLimit = parameters.fetchLimit {
            request.fetchLimit = fetchLimit
        }
        request.predicate = parameters.predicate
        request.sortDescriptors = parameters.sortDescriptors
        return request
    }
}

