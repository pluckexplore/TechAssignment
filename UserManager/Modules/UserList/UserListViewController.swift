import UIKit
import Combine

final class UserListViewController: UIViewController, UITableViewDelegate {
    private let viewModel: UserListViewModel
    private let router: Router
    private let output = PassthroughSubject<UserListViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.bounces = false
        return tableView
    }()
    
    private lazy var dataSource: UserListDataSource = {
        let dataSource = UserListDataSource(tableView: contentTableView) { [weak self] tableView, _, userData in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier),
                  let user = self?.viewModel.userWithEmail(userData.email) else {
                return UITableViewCell()
            }
            var content = cell.defaultContentConfiguration()
            content.text = user.name
            content.secondaryText = user.email
            cell.contentConfiguration = content
            return cell
        }
        dataSource.deleteUserAction = { [weak self] user in
            self?.output.send(.deleteUser(withEmail: user.email))
        }
        return dataSource
    }()
    
    init(viewModel: UserListViewModel, router: Router) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(Self.self).init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentTableView)
        configureNavigationBar()
        configureInitialDiffableSnapshot()
        startObserving()
        output.send(.viewDidLoad)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        contentTableView.setEditing(editing, animated: animated)
    }
}

private extension UserListViewController {
    
    func configureNavigationBar() {
        navigationItem.title = AppConstants.UserList.Title.navItem.rawValue
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onAddUserTapped)
        )
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    func configureInitialDiffableSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<UserListSection, UserData>()
        snapshot.appendSections([.users])
        snapshot.appendItems([])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func startObserving() {
        viewModel
            .transform(input: output.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] event in
                switch event {
                    case .setUsers(let users):
                        if users.isEmpty {
                            self.contentTableView.setEmptyMessage(AppConstants.UserList.Message.emptyList.rawValue)
                        } else {
                            self.contentTableView.restore()
                            var snapshot = dataSource.snapshot()
                            snapshot.deleteAllItems()
                            snapshot.appendSections([.users])
                            snapshot.appendItems(users, toSection: .users)
                            dataSource.apply(snapshot)
                        }
                }
            }.store(in: &cancellables)
    }
    
    @objc private func onAddUserTapped() {
        router.routeTo(.addUser)
    }
}


