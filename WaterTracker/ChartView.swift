import UIKit
import Charts
import ReactiveSwift
import Result

class ChartView: UIView, ChartViewDelegate {
    
    var barChartView = BarChartView()
    
    let viewModel: ChartViewModel
    
    let days = Day.allValues
    var numberOfFilledGlassesForWeek = MutableProperty<[Double]>([])

    
    init(frame: CGRect, values: [Double]) {
        self.numberOfFilledGlassesForWeek.value = values
        self.viewModel = ChartViewModel(values: values)
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        barChartView = BarChartView().then {
            $0.backgroundColor = .white
            $0.delegate = self
            
            //set the xAxis labels
            let xAxis = XAxis()
            let chartFormmater = ChartFormatter(viewModel.xAxisValues)
            
            for i in 0..<7 {
                chartFormmater.stringForValue(Double(i), axis: xAxis)
            }
            
            $0.xAxis.valueFormatter = chartFormmater
            
            //no data screen. should never show
            $0.noDataText = "Start logging water to see data!"
            $0.noDataFont = UIFont.body
            
            $0.drawBarShadowEnabled = false
            $0.drawValueAboveBarEnabled = false
            $0.rightAxis.enabled = false
            $0.drawGridBackgroundEnabled = false
            $0.xAxis.drawGridLinesEnabled = false
            $0.leftAxis.drawGridLinesEnabled = false
            $0.chartDescription?.text = ""
            $0.legend.enabled = false
            
            $0.leftAxis.labelFont = UIFont.body!
            $0.leftAxis.axisMinimum = 0
            $0.leftAxis.axisMaximum = 8
            
            $0.leftAxis.axisLineWidth = 3.0
            $0.xAxis.axisLineWidth = 3.0
            $0.xAxis.axisLineColor = UIColor.dark
            $0.drawBordersEnabled = false
            $0.xAxis.labelPosition = .bottom
            $0.xAxis.labelFont = UIFont.body!
            $0.animate(xAxisDuration: 0.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        }
        
        let dataSet = BarChartDataSet(values: viewModel.barChartDataEntries, label: "glasses for last week")
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        dataSet.colors = [UIColor.waterBlue]
        data.setDrawValues(false)
        
        addSubview(barChartView)
        barChartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bringSubview(toFront: barChartView)
    }
}

class ChartFormatter: IAxisValueFormatter {
    let xAxisValues: [String]
    
    init(_ values: [String]) {
        self.xAxisValues = values
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xAxisValues[Int(value)]
    }
}
