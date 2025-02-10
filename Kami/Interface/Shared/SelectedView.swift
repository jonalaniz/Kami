//
//  SelectedView.swift
//  Kami
//
//  Created by Jon Alaniz on 12/25/24.
//

import UIKit

/// A custom `UIView` that represents a selected view with a background color set to `.selection`.
///
/// This view is used to visually indicate selection by setting a specific background color.
/// It can be used in contexts where a highlighted or selected state needs to be visually represented.
class SelectedView: UIView {
    /// Initializes a `SelectedView` with a specified frame.
    ///
    /// This initializer sets the background color of the view to `.selection`.
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .selection
    }

    /// Initializes a `SelectedView` from a storyboard or nib.
    ///
    /// This initializer is not implemented and will throw a fatal error if called.
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
