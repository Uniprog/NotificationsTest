//
//  Presentable.swift

import UIKit

protocol Presentable: class {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
