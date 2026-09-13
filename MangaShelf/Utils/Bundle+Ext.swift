//
//  Bundle+Ext.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 09/09/26.
//

import Foundation

extension Bundle {
    static func appVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        return String(localized: "Version \(version) (\(build))")
    }
}
