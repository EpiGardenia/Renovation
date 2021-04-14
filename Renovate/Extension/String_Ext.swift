//
//  String_Ext.swift
//  Renovate
//
//  Created by T  on 2021-04-14.
//

import Foundation
extension String {

    /* using "genstrings -SwiftUI *.swift -s localize -o ." to get all String.localize(<to be parsed>) to be localized */
    public static func localize(_ key: String, tableName: String? = nil, comment: String? = nil) -> String {
        return NSLocalizedString(key, tableName: tableName, comment: comment ?? "")

    //    return NSLocalizedString(key, tableName: tableName, bundle: Bundle.main, value: "", comment: comment ?? "")
    }

}


