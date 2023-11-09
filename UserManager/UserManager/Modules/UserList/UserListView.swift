import UIKit

final class UserListContentViewCell: UITableViewCell, ReusableView {}

final class UserListController: UIViewController {
    
    var viewModel: UserListViewModelProtocol? {
        didSet {
            viewModel?.didUpdate = { [weak self] in
                Task { @MainActor in
                    self?.contentTableView.reloadData()
                }
            }
        }
    }
    
    private let contentTableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds)
        tableView.separatorStyle = .singleLine
        tableView.bounces = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentTableView)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UserListContentViewCell.self, forCellReuseIdentifier: UserListContentViewCell.reuseIdentifier)
        viewModel?.model?.triggerListUpdate()
    }
}

extension UserListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListContentViewCell.reuseIdentifier, for: indexPath) as? UserListContentViewCell else {
            return UITableViewCell()
        }
        let user = viewModel?.model?.users[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = user?.name ?? ""
        content.secondaryText = user?.email
        cell.contentConfiguration = content
        return cell
    }
}
