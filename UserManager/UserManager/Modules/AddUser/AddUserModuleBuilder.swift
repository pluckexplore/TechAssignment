import Foundation

struct AddUserModuleBuilder {
    static func buildView(engine: UsersEngine) -> AddUserViewController {
        let model = AddUserModel(engine: engine)
        let viewModel = AddUserViewModel(model: model)
        let view = AddUserViewController(viewModel: viewModel)
        return view
    }
}
