//
//  NameDescribable.swift
//  TheTaxiApp
//
//  Created by Sumit meena on 01/11/20.
//

import Foundation
import UIKit
import MapKit
protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
    static var identifier: String { get }
}

extension NameDescribable {
    var typeName: String {
        return String(describing: type(of: self))
    }
    static var typeName: String {
        return String(describing: self)
    }
    static var identifier: String {
        return String(describing: self)
    }
   
}

extension UITableViewCell: NameDescribable {}
extension MKAnnotationView : NameDescribable{}
//extension UIView : NameDescribable{}

