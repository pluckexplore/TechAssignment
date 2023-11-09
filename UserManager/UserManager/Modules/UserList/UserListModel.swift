import Foundation

protocol UserListModelProtocol {
    var users: [UserData] { get }
    var listDidChange: (() -> ())? { get set }
    init(engine: UserListEngine)
    func triggerListUpdate()
}

final class UserListModel: UserListModelProtocol {
    
    private let engine: UserListEngine
    
    private(set) var users: [UserData] = [] {
        didSet {
            listDidChange?()
        }
    }
    
    var listDidChange: (() -> ())?
    
    required init(engine: UserListEngine) {
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

