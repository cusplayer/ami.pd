//
//  DateHelper.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

class DateHelper {
    
    public static func prettyDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "в h:mm"
        } else if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "вчера в h:mm"
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy в h:mm"
        }
        return dateFormatter.string(from: date)
    }
    
}
