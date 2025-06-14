//
//  Symbols.swift
//  Kami
//
//  Created by Jon Alaniz on 12/20/24.
//

import UIKit

enum Symbol: String {
    case bell = "bell"
    case envelope = "envelope"
    case forward = "arrowshape.turn.up.forward"
    case merge = "arrow.triangle.merge"
    case notes = "square.and.pencil"
    case preferences = "gearshape"
    case reply = "arrowshape.turn.up.left"
    case trash = "trash"

    func image() -> UIImage? {
        return UIImage(systemName: self.rawValue)
    }
}
