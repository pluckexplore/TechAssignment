import Foundation

protocol DIContainerConfigProtocol {
    func registerContainerDependencies()
}

final class DIContainerConfig: DIContainerConfigProtocol {
    static let shared = DIContainerConfig()

    private init() {}

    func registerContainerDependencies() {
        let container = DIContainer.shared
        
        let storage = StorageDataProvider()
        let engine = UserListEngine(storage: storage)
        container.register(type: UserListEngine.self, component: engine)
    }
}

