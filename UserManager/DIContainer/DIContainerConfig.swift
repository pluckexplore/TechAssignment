import Foundation

enum DIContainerConfig {
    static func registerContainerDependencies() {
        let container = DIContainer.shared
        let stack = CoreDataStack(
            configuration: CoreDataStackConfiguration(
                modelName: AppConstants.DataBase.modelName.rawValue,
                storeType: .onDisk
            )
        )
        let storage = UserStorageDataProvider(coreDataStack: stack)
        let engine = UsersEngine(storage: storage)
        container.register(type: UsersEngine.self, component: engine)
    }
}

