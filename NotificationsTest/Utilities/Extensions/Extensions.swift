//
//  Extensions.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation
import UIKit

extension UIViewController {
    class func instantiate<T: UIViewController>(storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}

extension UIFont {
    enum OpenSans: String {
        case regular = "OpenSans"
        case italic = "OpenSans-Italic"
        case light = "OpenSans-Light"
        case lightItalic = "OpenSansLight-Italic"
        case semibold = "OpenSans-Semibold"
        case semiboldItalic = "OpenSans-SemiboldItalic"
        case bold = "OpenSans-Bold"
        case boldItalic = "OpenSans-BoldItalic"
        case extrabold = "OpenSans-Extrabold"
        case extraboldItalic = "OpenSans-ExtraboldItalic"
    }
    
    static func openSans(type: UIFont.OpenSans, size: CGFloat) -> UIFont? {
        return UIFont(name: type.rawValue, size: size)
    }
}

extension UIFont {
    static func printAllFonts() {
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
    }
}

extension UserDefaults {
    func save<T>(_ value: T, forKey: String) where T: Encodable {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: forKey)
        }
    }
    
    func load<T>(forKey: String) -> T? where T: Decodable {
        guard let data = self.value(forKey: forKey) as? Data,
              let decodedData = try? JSONDecoder().decode(T.self, from: data)
        else { return nil }
        return decodedData
    }
}

extension MutableCollection where Self : RandomAccessCollection {
    mutating func sort(
        by firstPredicate: (Element, Element) -> Bool,
        _ secondPredicate: (Element, Element) -> Bool,
        _ otherPredicates: ((Element, Element) -> Bool)...
    ) {
        sort(by:) { lhs, rhs in
            if firstPredicate(lhs, rhs) { return true }
            if firstPredicate(rhs, lhs) { return false }
            if secondPredicate(lhs, rhs) { return true }
            if secondPredicate(rhs, lhs) { return false }
            for predicate in otherPredicates {
                if predicate(lhs, rhs) { return true }
                if predicate(rhs, lhs) { return false }
            }
            return false
        }
    }
}

extension Sequence {
    mutating func sorted(
        by firstPredicate: (Element, Element) -> Bool,
        _ secondPredicate: (Element, Element) -> Bool,
        _ otherPredicates: ((Element, Element) -> Bool)...
    ) -> [Element] {
        return sorted(by:) { lhs, rhs in
            if firstPredicate(lhs, rhs) { return true }
            if firstPredicate(rhs, lhs) { return false }
            if secondPredicate(lhs, rhs) { return true }
            if secondPredicate(rhs, lhs) { return false }
            for predicate in otherPredicates {
                if predicate(lhs, rhs) { return true }
                if predicate(rhs, lhs) { return false }
            }
            return false
        }
    }
}
