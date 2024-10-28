//
//  UIStackView+.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
