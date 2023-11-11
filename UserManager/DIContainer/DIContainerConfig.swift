import Foundation

enum DIContainerConfig {
    static func registerContainerDependencies() {
        let container = DIContainer.shared
        let storage = StorageDataProvider()
        let engine = UsersEngine(storage: storage)
        container.register(type: UsersEngine.self, component: engine)
    }
}

