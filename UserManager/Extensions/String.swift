import Foundation

extension String {
    var isValidEmail: Bool {
        NSPredicate.emailPredicate.evaluate(with: self)
    }
}

