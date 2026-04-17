//
//  RunFormatter.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import Foundation

struct RunFormatter {
    
    // input: seconds per meter
    static func pace(_ secondsPerMeter: Double) -> String {
        guard secondsPerMeter > 0 else { return "--'--\"" }
        let secondsPerMile = secondsPerMeter * 1609.344
        let minutes = Int(secondsPerMile) / 60
        let seconds = Int(secondsPerMile) % 60
        return String(format: "%d'%02d\"", minutes, seconds)
    }
    
    // input: meters into miles
    static func distance(_ meters: Double) -> String {
        let miles = meters / 1609.344
        return String(format: "%.2f", miles)
    }
    
    // input: seconds
    static func duration(_ seconds: Double) -> String {
        let hrs = Int(seconds) / 3600
        let mins = Int(seconds) % 3600 / 60
        let secs = Int(seconds) % 60
        
        if hrs > 0 {
            return String(format: "%d:%02d:%02d", hrs, mins, secs)
        } else {
            return String(format: "%d:%02d", mins, secs)
        }
    }
    
    // input: meters
    static func elevation(_ meters: Double) -> String {
        let feet = meters * 3.28084
        return String(format: "%.0f ft", feet)
    }
    
    // range dates
    static func timeRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    // returns Thursday, April 3
    static func date(_ date: Date) -> String {
        date.formatted(.dateTime.weekday(.wide).month(.wide).day())
    }
    // returns 4/2/26
    static func numberDate(_ date: Date) -> String {
        date.formatted(.dateTime.month(.defaultDigits).day(.defaultDigits).year(.twoDigits))
    }
    
    // returns "date / time"
    static func dateAndTime(_ date: Date) -> String {
        date.formatted(.dateTime.month(.wide).day()) + " / " + date.formatted(.dateTime.hour().minute())
    }
    
    static func heartRate(_ bpm: Double) -> String {
        return "\(Int(bpm)) bpm"
    }
    
    // pace difference from average pace
    static func paceDiff(_ secondsPerMeter: Double) -> String {
        let secondsPerMile = secondsPerMeter * 1609.344
        let abs = Int(Swift.abs(secondsPerMile))
        let minutes = abs / 60
        let seconds = abs % 60
        let sign = secondsPerMile > 0 ? "+" : "-"
        return String(format: "%@%d'%02d\"", sign, minutes, seconds)
    }
    
    // depending on time of day return Thursday... Morning, Noon, Afternoon, or Night Run
    
    static func timeOfDay(_ date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let weekday = calendar.weekdaySymbols[calendar.component(.weekday, from: date) - 1] // "Thursday"
        
        let timeOfDay: String
        switch hour {
        case 5..<12:  timeOfDay = "Morning Run"
        case 12..<17: timeOfDay = "Afternoon Run"
        case 17..<21: timeOfDay = "Evening Run"
        default:      timeOfDay = "Night Run"
        }
        
        return "\(weekday) \(timeOfDay)"
    }
}
