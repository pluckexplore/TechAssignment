import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @NSManaged public var email: String
    @NSManaged public var name: String
}

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: Self.description())
    }
}

