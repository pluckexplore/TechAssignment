import Foundation
import Combine

class UserListViewModel {

    enum Input {
        case viewDidLoad
        case viewWillAppear
        case deleteUser(withEmail: String)
    }
    enum Output {
        case setUsers(users: [UserData])
    }

    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()

    private let model: UserListModel
    
    var itemsCount: Int {
        return model.users.count
    }

    init(model: UserListModel) {
        self.model = model
        model.listDidChange = { [weak self] in
            self?.sendUsers()
        }
    }
    
    func userWithEmail(_ email: String) -> UserData? {
        return model.users.first {  $0.email == email }
    }
    
    private func sendUsers() {
        output.send(.setUsers(users: model.users))
    }
    
    func triggerModelUpdate() {
        model.triggerListUpdate()
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [unowned self] event in
                switch event {
                case .viewDidLoad, .viewWillAppear:
                    self.sendUsers()
                case .deleteUser(let email):
                    let deleted = self.model.deleteUser(withEmail: email)
                    if case Result.failure(let error) = deleted {
                        SimpleMessage.displayComfiguredWithTheme(
                            .failure,
                            withTitle: AppConstants.UserList.Message.deletionError.rawValue,
                            withBody: error.localizedDescription
                        )
                    }
                }
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

