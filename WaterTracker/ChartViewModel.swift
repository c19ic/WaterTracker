import Foundation
import ReactiveSwift
import Result
import Charts

class ChartViewModel {
    let yAxisValues = MutableProperty<[Double]>([])
    let xAxisValues = Day.abbreviations
    let barChartData: BarChartData
    
    init(values: [Double]) {
        self.yAxisValues.value = values
    }
    
    private var barChartDataEntries: [BarChartDataEntry] {
        var dataEntries = [BarChartDataEntry]()
        for i in 0..<yAxisValues.value.count {
            let entry = BarChartDataEntry(x: Double(i), y: (yAxisValues.value[i]))
            dataEntries.append(entry)
        }
        
        return dataEntries
    }
    
    private var barChartDataSet: BarChartDataSet {
        return BarChartDataSet(values: barChartDataEntries, label: "data set")
    }
    
    func updateData()
    
}
