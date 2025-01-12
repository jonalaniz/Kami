//
//  SelectedView.swift
//  Kami
//
//  Created by Jon Alaniz on 12/25/24.
//

import UIKit

class SelectedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .selection
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
