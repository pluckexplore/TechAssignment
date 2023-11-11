import UIKit

final class Router {
    
    enum Route {
        case addUser
    }
    
    private let engine: UsersEngine
    private(set) lazy var navigationController = UINavigationController(rootViewController: userList)
    private lazy var userList = UserListModuleBuilder.buildView(engine: engine, router: self)
    private lazy var addUser = AddUserModuleBuilder.buildView(engine: engine)
    
    init(engine: UsersEngine) {
        self.engine = engine
    }
    
    func routeTo(_ route: Route) {
        switch route {
        case .addUser:
            navigationController.pushViewController(addUser, animated: true)
        }
    }
}
