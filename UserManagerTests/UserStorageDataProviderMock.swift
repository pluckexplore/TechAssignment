import Foundation
@testable import UserManager

final class UserStorageDataProviderMock: UserStorageDataProvider {
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
