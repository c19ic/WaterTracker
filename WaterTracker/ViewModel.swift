import Foundation

enum Day: String {
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    static let allValues: [String] = [Sunday.rawValue, Monday.rawValue, Tuesday.rawValue, Wednesday.rawValue, Thursday.rawValue, Friday.rawValue, Saturday.rawValue]
}

class ViewModel {
    
    private var defaults: UserDefaults
    var day: Day
    var date: Date
    
    var currentNumberOfFilledGlasses: Int
    
    init() {
        self.defaults = UserDefaults.standard
        self.date = Date()
        guard let dayOfWeek = date.dayOfWeek else { fatalError() }
        guard let day = Day(rawValue: dayOfWeek) else { fatalError() }
        self.day = day
        self.currentNumberOfFilledGlasses = defaults.integer(forKey: day.rawValue)
        
        if day == .Saturday {
            Day.allValues.forEach { (day) in
                if day != "Saturday" {
                    defaults.removeObject(forKey: day)
                }
            }
        }
    }
    
    func incrementNumberOfGlasses() {
        let currentNumberOfGlasses = defaults.integer(forKey: day.rawValue)
        defaults.set(currentNumberOfGlasses+1, forKey: day.rawValue)
    }
    
    func clearDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
    }
    
    var pastWeekNumberOfGlasses: [String] {
        var answer = [String]()
        Day.allValues.forEach { (day) in
            answer.append(String(defaults.integer(forKey: day)))
        }
        return answer
    }
}

extension Date {
    var dayOfWeek: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
