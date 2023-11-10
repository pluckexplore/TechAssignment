import UIKit
import Combine

class AddUserController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    private let viewModel: AddUserViewModel
    
    init(viewModel: AddUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textContentType = .name
        textField.keyboardType = .namePhonePad
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.placeholder = "Name"
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        return textField
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit user", for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupPublishers()
    }
    
    private func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(submitButton)
        navigationItem.title = "aaa"
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            submitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func setupPublishers() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: nameTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.name, on: viewModel)
            .store(in: &cancellables)
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isSubmitEnabled
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &cancellables)
        
        viewModel.$state
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.submitButton.isEnabled = false
                    self?.submitButton.setTitle("Loading..", for: .normal)
                case .success:
                    self?.resetButton()
                    SimpleMessage.displayComfiguredWithTheme(.success, withTitle: "Done", withBody: "User saved.")
                    self?.navigationController?.popViewController(animated: true)
                case .failed:
                    self?.resetButton()
                    SimpleMessage.displayComfiguredWithTheme(.failure, withTitle: "Error", withBody: "User already exists.")
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func onSubmit() {
        viewModel.submit()
    }
    
    func resetButton() {
        submitButton.setTitle("Submit user", for: .normal)
        submitButton.isEnabled = true
    }
}
