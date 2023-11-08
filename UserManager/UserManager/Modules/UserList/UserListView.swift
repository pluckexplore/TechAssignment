import UIKit

final class UserListContentViewCell: UITableViewCell, ReusableView {}

final class UserListController: UIViewController {
    
    private let userListFetcher: UserListFetcher
    
    var viewModel: UserListViewModelProtocol? {
        didSet {
            viewModel?.listDidChange = { [weak self] _ in
                self?.contentTableView.reloadData()
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
        getRemoteUsers()
    }
    
    init(fetcher: UserListFetcher) {
        self.userListFetcher = fetcher
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getRemoteUsers() {
        Task {
            do {
                let users: [UserData] = try await userListFetcher.getRemoteUsers()
                viewModel?.addUsers(users)
            } catch {
                debugPrint(error)
            }
        }
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
