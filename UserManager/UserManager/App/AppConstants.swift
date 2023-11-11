import Foundation

enum AppConstants {
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
            case done = "Done"
            case saved = "User saved"
            case error = "Error"
            case alreadyExists = "User already exists"
            case loading = "Loading..."
        }
    }
}
