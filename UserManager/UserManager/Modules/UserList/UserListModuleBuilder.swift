import Foundation

final class UserListModuleBuilder {
    static func buildView(engine: UsersEngine, router: Router) -> UserListController {
        let model = UserListModel(engine: engine)
        let viewModel = UserListViewModel(model: model)
        let view = UserListController(viewModel: viewModel, router: router)
        return view
    }
}
