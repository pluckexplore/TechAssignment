import Foundation
import Combine

class UserListViewModel {

    enum Input {
        case viewDidLoad
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
        let users = model.users.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        output.send(.setUsers(users: users))
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [unowned self] event in
                switch event {
                case .viewDidLoad:
                    self.model.mergeLocalUsersWithRemote()
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

