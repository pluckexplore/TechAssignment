import Foundation
@testable import UserManager

final class UserStorageProviderMock: UserStorageProvider {
    convenience init() {
        let stack = CoreDataStack(
            configuration: CoreDataStackConfiguration(
                modelName: AppConstants.DataBase.modelName.rawValue,
                storeType: .inMemory
            )
        )
        self.init(coreDataStack: stack)
    }
}
