import Foundation
import Combine

class AddUserViewModel: ObservableObject {
    
    private let model: AddUserModel
    
    enum ViewState {
        case loading
        case success
        case failed(Error)
        case none
    }
    @Published var name = ""
    @Published var email = ""
    @Published var state: ViewState = .none
    
    var isValidNamePublisher: AnyPublisher<Bool, Never> {
        $name
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .map { $0.isValidName }
            .eraseToAnyPublisher()
    }
    var isValidEmailPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .map { $0.isValidEmail }
            .eraseToAnyPublisher()
    }
    
    var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidNamePublisher, isValidEmailPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    init(model: AddUserModel) {
        self.model = model
    }

    func submit() {
        state = .loading
        switch model.addUser(withName: name, withEmail: email) {
        case .success:
            self.state = .success
        case .failure(let error):
            self.state = .failed(error)
        }
    }
}

fileprivate extension String {
    
    var isValidName: Bool {
        return self.count > 3
    }
    
    var isValidEmail: Bool {
        NSPredicate.emailPredicate.evaluate(with: self)
    }
}

extension NSPredicate {
    static let emailPredicate = NSPredicate(
        format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    )
}
