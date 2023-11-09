import Foundation

protocol UserListViewModelProtocol {
    var model: UserListModelProtocol? { get }
    var didUpdate: (() -> Void)? { get set }
    func triggerModelUpdate()
}

class UserListViewModel: UserListViewModelProtocol {
    
    var model: UserListModelProtocol? {
        didSet {
            model?.listDidChange = { [weak self] in
                self?.didUpdate?()
            }
        }
    }
    
    var didUpdate: (() -> Void)?

    func triggerModelUpdate() {
        model?.triggerListUpdate()
    }
}

