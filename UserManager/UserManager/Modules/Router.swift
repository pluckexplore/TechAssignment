import UIKit

final class Router {
    
    enum Route {
        case addUser
    }
    
    private let engine: UsersEngine
    private(set) lazy var navigationController = UINavigationController(rootViewController: userList)
    private lazy var userList = UserListModuleBuilder.buildView(engine: engine, router: self)

    init(engine: UsersEngine) {
        self.engine = engine
    }
    
    func routeTo(_ route: Route) {

    }
}
