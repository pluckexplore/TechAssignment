import Foundation

enum UserListModuleBuilder {
    static func buildView(engine: UsersEngine, router: Router) -> UserListViewController {
        let model = UserListModel(engine: engine)
        let viewModel = UserListViewModel(model: model)
        let view = UserListViewController(viewModel: viewModel, router: router)
        return view
    }
}
