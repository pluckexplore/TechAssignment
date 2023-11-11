import Foundation
import Combine

final class AddUserViewModel: ObservableObject {

    enum ViewState {
        case loading
        case success
        case failed(Error)
        case none
    }
    
    enum InputValidationError: Error {
        case invalidName
        case invalidEmail
        
        var warningMessage: String {
            switch self {
                case .invalidName:
                    return AppConstants.AddUser.Message.invalidName.rawValue
                case .invalidEmail:
                    return AppConstants.AddUser.Message.invalidEmail.rawValue
            }
        }
    }
    
    @Published var name = ""
    @Published var email = ""
    @Published var state: ViewState = .none
    
    private let model: AddUserModel

    init(model: AddUserModel) {
        self.model = model
    }
    
    func checkForCorrectInput() -> Result<Void, InputValidationError> {
        guard name.count >= 5, name.count <= 20 else {
            return .failure(InputValidationError.invalidName)
        }
        guard email.isValidEmail else {
            return .failure(InputValidationError.invalidEmail)
        }
        return .success(())
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


