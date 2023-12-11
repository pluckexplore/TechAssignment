import CoreData

enum UserStorageProviderTask: StorageProviderTask {
    typealias T = User
    case fetchAll
    case fetchWithEmail(String)
    
    func taskRequest() throws -> NSFetchRequest<User> {
        var parameters = FetchRequestBuilder.Parameters()
        switch self {
            case .fetchAll:
                let compareSelector = #selector(NSString.localizedStandardCompare(_:))
                let sortDescriptor = NSSortDescriptor( key: #keyPath(User.name), ascending: true, selector: compareSelector)
                parameters.sortDescriptors?.append(sortDescriptor)
            case .fetchWithEmail(let email):
                let predicate = NSPredicate(format: "email == %@", email)
                parameters.predicate = predicate
                parameters.fetchLimit = 1
        }
        let request = try FetchRequestBuilder.build(parameters: parameters) as NSFetchRequest<User>
        return request
    }
}

