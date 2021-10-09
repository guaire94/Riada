//
//  Timestamp+M.swift
//  Riada
//
//  Created by Quentin Gallois on 01/11/2020.
//

import FirebaseFirestore

extension Timestamp {
    
    var long: String {
        dateValue().long
    }
    
    var short: String {
        dateValue().short
    }

    var hour: String {
        dateValue().hour
    }
}

extension Date {
    
    var timestamp: Timestamp {
        Timestamp(date: self)
    }

    var long: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    var short: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    
    var hour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    var timeAgo: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }

    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}
