import Foundation

final class UserListModuleBuilder {
    static func buildView(engine: UserListEngine) -> UserListController {
        let model = UserListModel(engine: engine)
        let viewModel = UserListViewModel()
        viewModel.model = model
        let view = UserListController()
        view.viewModel = viewModel
        return view
    }
}
