//
//  Date+Extension.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/16/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

extension Date {
    /// Returns the time difference between the receiver and the passed argument as an optional String.
    ///
    /// Difference String is returned if the receiver is younger in age than that of the argument, otherwise returns nil.
    ///
    /// - Remark: The return format is **__ hour(s) & __ minute(s)** or **__ minute(s)**
    ///
    /// - Precondition: The receiver must be younger than the date passed as an argument.
    /// - Parameter dateInFuture: A Date in the future that is older than the receiver.
    /// - Returns: An optional String in the format of human readable time difference
    func howLongUntil(dateInFuture: Date) -> String? {
        guard self < dateInFuture else { return nil }
        let calendar = Calendar.current
        let futureTimeComponents = calendar.dateComponents([.hour, .minute], from: dateInFuture)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: self)
        let dateComponents = calendar.dateComponents([.hour, .minute], from: nowComponents, to: futureTimeComponents)
        var hourString = ""
        if let hour = dateComponents.hour, hour > 0 {
            hourString = "\(hour)"
            hourString += hour > 1 ? " hours" : " hour"
        }
        var minuteString = ""
        if let minute = dateComponents.minute, minute > 0 {
            minuteString = "\(minute)"
            minuteString += minute > 1 ? " minutes" : " minute"
        }
        let hourAndMinuteString = !hourString.isEmpty ? [hourString, minuteString].joined(separator: " & ") : !minuteString.isEmpty ? minuteString : nil
        return hourAndMinuteString
    }

    /// Returns the time difference between the receiver and the passed argument as an optional String.
    ///
    /// Difference String is returned if the receiver is older in age than that of the argument, otherwise returns nil.
    ///
    /// - Remark: The return format is **__ hour(s) & __ minute(s)** or **__ minute(s)**
    ///
    /// - Precondition: The receiver must be older than the date passed as an argument.
    /// - Parameter dateInPast: A Date in the past that is younger than the receiver.
    /// - Returns: An optional String in the format of human readable time difference
    func howLongFrom(dateInPast: Date) -> String? {
        return dateInPast.howLongUntil(dateInFuture: self)
    }

}
