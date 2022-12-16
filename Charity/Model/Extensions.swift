//
//  Extensions.swift
//  Charity
//
//  Created by Al Stark on 30.11.2022.
//

import Foundation
import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
