import UIKit
import Charts

class ChartView: UIView, ChartViewDelegate {

    let barChartView = BarChartView()
    
    let days = Day.allValues
    var numberOfFilledGlassesForWeek: [String]
    
    init(frame: CGRect, values: [String]) {
        self.numberOfFilledGlassesForWeek = values
        super.init(frame: frame)
        setup()
        populateBarChart()
        addSubview(barChartView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateBarChart() {
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<numberOfFilledGlassesForWeek.count {
            let entry = BarChartDataEntry(x: Double(i), y: Double(numberOfFilledGlassesForWeek[i])! + 1)
            dataEntries.append(entry)
        }
        
        let dataSet = BarChartDataSet(values: dataEntries, label: "glasses for last week")
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        data.setDrawValues(false)
        dataSet.colors = [UIColor.waterBlue]
    }
    
    func setup() {
        barChartView.delegate = self
        let formatter = ChartFormatter()
        barChartView.xAxis.valueFormatter = formatter
        barChartView.noDataText = "Start logging water to see data!."
        barChartView.noDataFont = UIFont.body

        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = true
        
        barChartView.pinchZoomEnabled = false
        barChartView.drawGridBackgroundEnabled = true
        barChartView.drawBordersEnabled = false
    }
   
}

class ChartFormatter: IAxisValueFormatter {
    var days = Day.allValues
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return days[Int(value)]
    }
}
