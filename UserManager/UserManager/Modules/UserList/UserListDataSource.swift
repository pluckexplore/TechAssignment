import UIKit

enum UserListSection: Int {
    case users = 0
    var title: String? {
        switch self {
            case .users:
                return AppConstants.UserList.Title.usersSection.rawValue
        }
    }
}

final class UserListDataSource: UITableViewDiffableDataSource<UserListSection, UserData> {
    
    var deleteUserAction: ((UserData) -> Void)?
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let listSection = UserListSection(rawValue: section)
        return listSection?.title
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let userData = itemIdentifier(for: indexPath) else { return }
            var currentSnapshot = snapshot()
            currentSnapshot.deleteItems([userData])
            apply(currentSnapshot)
            deleteUserAction?(userData)
        }
    }
}
