import Foundation

enum AppConstants {
    
    enum UserList {
        enum Title: String {
            case navItem = "Users List"
            case usersSection = "Users"
        }
        enum Message: String {
            case emptyList = "User list is empty..."
            case deletionError = "Deletion Error"
        }
    }

    enum AddUser {
        enum ViewConstraint: CGFloat {
            case defaultSpacing = 24
            case defaultHeight = 48
        }
        enum Title: String {
            case navItem = "Add User"
            case name = "Name"
            case email = "Email"
            case submit = "Submit"
        }
        enum Message: String {
            case validationWarning = "Validation warning"
            case invalidName = "Name should be from 5 to 20 symbols long"
            case invalidEmail = "Email is not valid"
            case done = "Done"
            case saved = "User saved"
            case error = "Error"
            case alreadyExists = "User already exists"
            case loading = "Loading..."
        }
    }
}
