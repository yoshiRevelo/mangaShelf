//
//  Decimal+Ext.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 30/08/26.
//

import Foundation

extension Decimal {
    var toString: String {
        let data = self
        return data.formatted(.number.precision(.fractionLength(2)))
    }
}
