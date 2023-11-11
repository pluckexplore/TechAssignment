import Foundation
import SwiftMessages

enum SimpleMessage {
    enum Theme {
        case success, failure, warning
    }
    static func displayConfiguredWithTheme(_ theme: Theme, withTitle title: String, withBody body: String) {
        
        SwiftMessages.show {
            let view = MessageView.viewFromNib(layout: .cardView)
            switch theme {
                case .success:
                    view.configureTheme(.success)
                case .failure:
                    view.configureTheme(.error)
                case .warning:
                    view.configureTheme(.warning)
            }
            view.configureContent(title: title, body: body)
            view.button?.isHidden = true
            return view
        }
    }
}

