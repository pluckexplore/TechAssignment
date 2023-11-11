import Foundation

extension NSPredicate {
    static let emailPredicate = NSPredicate(
        format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    )
}

