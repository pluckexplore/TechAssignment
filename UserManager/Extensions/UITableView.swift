import UIKit

extension UITableView {
    
    var emptyMessageLabel: UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        label.textColor = .darkText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }
    
    func setEmptyMessage(_ message: String) {
        let label = emptyMessageLabel
        label.text = message
        backgroundView = label
    }

    func restore() {
        backgroundView = nil
    }
}

