//
//  ControllerDelegate.swift
//  Kami
//
//  Created by Jon Alaniz on 12/1/24.
//

import Foundation

protocol DataManagerDelegate: AnyObject {
    func dataUpdated()
    func tableViewHeightUpdated()
}
