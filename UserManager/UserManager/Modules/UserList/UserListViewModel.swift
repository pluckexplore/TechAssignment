import Foundation
import Combine

class UserListViewModel {

    enum Input {
        case viewDidLoad
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
    
    func userForRowAtIndexPath(_ row: Int) -> UserData {
        return model.users[row]
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
                    case .viewDidLoad:
                        self.sendUsers()
                }
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

