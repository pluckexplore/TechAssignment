import UIKit
import Combine

final class UserListController: UIViewController {
    private let viewModel: UserListViewModel
    private let router: Router
    private let output = PassthroughSubject<UserListViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let contentTableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds)
        tableView.separatorStyle = .singleLine
        tableView.bounces = false
        return tableView
    }()
    
    init(viewModel: UserListViewModel, router: Router) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(Self.self).init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.triggerModelUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentTableView)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAdddUserTapped))
        navigationItem.setRightBarButton(addButton, animated: false)
        observe()
        output.send(.viewDidLoad)
    }
    
    private func observe() {
        viewModel.triggerModelUpdate()
        viewModel
            .transform(input: output.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] event in
                switch event {
                    case .setUsers:
                        self.contentTableView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    @objc private func onAdddUserTapped() {
        router.routeTo(.addUser)
    }
}

extension UserListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        let user = viewModel.userForRowAtIndexPath(indexPath.row)
        var content = cell.defaultContentConfiguration()
        content.text = user.name
        content.secondaryText = user.email
        cell.contentConfiguration = content
        return cell
    }
}
