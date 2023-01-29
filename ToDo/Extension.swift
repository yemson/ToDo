//
//  Extension.swift
//  ToDo
//
//  Created by 이예민 on 2023/01/29.
//

import Foundation

extension Formatter {
    static let weekDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "dd일, EEEE"
        return formatter
    }()
    
    static let hour: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "dd일, a h:mm"
        return formatter
    }()
}
