import Foundation

protocol UserListViewModelProtocol {
    var model: UserListModel? { get }
    var listDidChange: ((UserListViewModelProtocol) -> ())? { get set }
    init(model: UserListModel)
    func addUsers(_ users: [UserData])
}

class UserListViewModel: UserListViewModelProtocol {
    
    var model: UserListModel? {
        didSet {
            listDidChange?(self)
        }
    }
    
    var listDidChange: ((UserListViewModelProtocol) -> ())?
    
    required init(model: UserListModel) {
        self.model = model
    }

    func addUsers(_ users: [UserData]) {
        model?.users.append(contentsOf: users)
    }
}

