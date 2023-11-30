import Foundation
import CoreData

struct CoreDataStackConfiguration {
    enum StoreType {
        case inMemory, onDisk
    }
    let modelName: String
    let storeType: StoreType
}

final class CoreDataStack {
    
    private let configuration: CoreDataStackConfiguration
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: configuration.modelName)
        if configuration.storeType == .inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Failed to load the database!")
            }
        }
        return container
    }()
    
    private(set) lazy var managedContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    init(configuration: CoreDataStackConfiguration) {
        self.configuration = configuration
    }
}

