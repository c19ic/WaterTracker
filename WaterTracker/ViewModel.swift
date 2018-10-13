import Foundation
import ReactiveSwift
import Result

enum Day: String {
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    static let allValues: [String] = [Sunday.rawValue, Monday.rawValue, Tuesday.rawValue, Wednesday.rawValue, Thursday.rawValue, Friday.rawValue, Saturday.rawValue]
    static let abbreviations = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
}

class ViewModel {
    
    let (incrementWaterSignal, incrementWaterObserver) = Signal<Bool, NoError>.pipe()
    
    let formatter = DateFormatter().then {
        $0.dateStyle = .short
    }
    
    private var defaults: UserDefaults
    var date: String
    
    var currentNumberOfFilledGlasses: Double
    
    init() {
        self.defaults = UserDefaults.standard
        self.date = formatter.string(from: Date())
        self.currentNumberOfFilledGlasses = defaults.double(forKey: date)
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        
        defaults.removeObject(forKey: formatter.string(from: lastWeekDate))
    }
    
    func incrementNumberOfGlasses() {
        let currentNumberOfGlasses = defaults.double(forKey: date)
        defaults.set(currentNumberOfGlasses + 1, forKey: date)
        incrementWaterObserver.send(value: true)
    }
    
    func clearDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
    }
    
    var pastWeekNumberOfGlasses: [Double] {
        var answer = [Double]()
        let formatter = DateFormatter().then {
            $0.dateStyle = .short
        }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        print(days)
        
        for day in days {
            answer.append(defaults.double(forKey: formatter.string(from: day)))
        }
        print(answer)
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
