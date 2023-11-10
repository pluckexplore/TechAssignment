import Foundation

struct AddUserModuleBuilder {
    static func buildView(engine: UsersEngine) -> AddUserController {
        let model = AddUserModel(engine: engine)
        let viewModel = AddUserViewModel(model: model)
        let view = AddUserController(viewModel: viewModel)
        return view
    }
}
