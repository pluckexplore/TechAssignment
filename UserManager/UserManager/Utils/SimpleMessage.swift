import Foundation
import SwiftMessages

struct SimpleMessage {
    enum Theme {
        case success, failure
    }
    static func displayComfiguredWithTheme(_ theme: Theme, withTitle title: String, withBody body: String) {
        
        SwiftMessages.show {
            let view = MessageView.viewFromNib(layout: .cardView)
            switch theme {
            case .success:
                view.configureTheme(.success)
            case .failure:
                view.configureTheme(.error)
            }
            view.configureContent(title: title, body: body)
            view.button?.isHidden = true
            return view
        }
    }
}

