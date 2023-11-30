struct UserData: Decodable, Hashable {
    let name: String
    let email: String
}

extension UserData {
    init(userObject: User) {
        self.name = userObject.name
        self.email = userObject.email
    }
}
