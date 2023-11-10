import Foundation

final class UserListModel {
    
    private let engine: UsersEngine
    
    private(set) var users: [UserData] = [] {
        didSet {
            listDidChange?()
        }
    }
    
    var listDidChange: EmptyBlock?
    
    init(engine: UsersEngine) {
        self.engine = engine
    }
    
    func triggerListUpdate() {
        Task.detached { [weak self] in
            guard let self = self else { return }
            do {
                try await self.engine.merge()
                self.users = self.engine.getUsersFromStorage()
            } catch {
                debugPrint(error)
            }
        }
    }
}

