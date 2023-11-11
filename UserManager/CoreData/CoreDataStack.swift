import Foundation
import CoreData

final class CoreDataStack {
    
    private let modelName: String
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
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
    
    init(modelName: String) {
        self.modelName = modelName
    }
}

