import Foundation

struct AddUserModel {
    private(set) var engine: UsersEngine
    func addUser(withName name: String, withEmail email: String) -> Result<Void, Error> {
        do {
            let userData = UserData(name: name, email: email)
            return try engine.saveUser(withData: userData)
        } catch {
            return .failure(error)
        }
    }
}

