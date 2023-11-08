import Foundation

struct UserListModule {
    let model: UserListModel
    let viewModel: UserListViewModelProtocol
    let view: UserListController
}

final class UserListModuleBuilder {
    static func buildView() -> UserListController {
        let fetcher = UserListFetcher()
        let model = UserListModel(users: fetcher.getLocalUsers())
        let viewModel = UserListViewModel(model: model)
        let view = UserListController(fetcher: fetcher)
        view.viewModel = viewModel
        return view
    }
}
