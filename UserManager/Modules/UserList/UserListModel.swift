import Foundation
import Combine

final class UserListModel {
    
    private let engine: UsersEngine
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) lazy var users: [UserData] = [] {
        didSet {
            listDidChange?()
        }
    }
    
    var listDidChange: (() -> Void)?
    
    init(engine: UsersEngine) {
        self.engine = engine
        setupPublisher()
    }
    
    func setupPublisher() {
        self.engine.$localUsers
            .sink { [ unowned self ] newUsers in
                self.users = newUsers
            }.store(in: &cancellables)
    }
    
    func mergeLocalUsersWithRemote() {
        Task.detached {
            do {
                try await self.engine.merge()
            } catch {
                debugPrint(error)
            }
        }
    }
    
    func deleteUser(withEmail email: String) -> Result<Void, Error> {
        do {
            try engine.deleteUser(withEmail: email)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

