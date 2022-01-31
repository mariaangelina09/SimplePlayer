//
//  UIExtension.swift
//  SimplePlayer
//
//  Created by Maria Angelina on 29/01/22.
//

import Foundation
import UIKit

// MARK: - UIView Extension(s)
protocol NibLoadableView: class {}
extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

protocol ReusableView: class {}
extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - UITableView Extension(s)
extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

// MARK: - UIColor Extension(s)
extension UIColor {
    static let mainColor = UIColor(red: 240/255, green: 110/255, blue: 110/255, alpha: 1)
}
