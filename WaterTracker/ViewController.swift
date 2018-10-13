import UIKit
import Then
import SnapKit
import Charts
import ReactiveSwift
import Result

class ViewController: UIViewController {
    private var holderViews = [HolderView]()
    private var waterGlassView: UICollectionView!
    private let waterGlassReuse: String = "Glass"
    private let titleString: String = "got water?"
    private var barChartView: ChartView!
    private var navBar: UINavigationItem!
    
    var days = [String]()
    var numberOfFilledGlasses = [String]()
    
    private var viewModel: ViewModel!
    
    private enum Layout {
        static let numberOfGlasses = 8
        static let insets = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        static let waterGlassViewHeight = 300
        static let barChartHeight = 250
        static let navBarHeight: CGFloat = 44
        static let holderViewHeight: CGFloat = 100
        static let holderViewWidth: CGFloat = 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        refillGlassesWhenReopened()
    }
}

//MARK: - Setup
extension ViewController: HolderViewDelegate {
    private func setup() {
        //Water glass view
        let layout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
            $0.itemSize = CGSize(width: self.view.frame.width / 5.5, height: 115)
            $0.minimumLineSpacing = CGFloat(Layout.waterGlassViewHeight - (2 * 130))
            $0.minimumInteritemSpacing = 17
        }
        waterGlassView = UICollectionView(frame: view.frame, collectionViewLayout: layout).then {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: waterGlassReuse)
            $0.backgroundColor = .white
            $0.isScrollEnabled = false
        }
        view.addSubview(waterGlassView)
        waterGlassView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(view.frame.height * 7 / 16)
            make.left.right.equalToSuperview().inset(Layout.insets)
            make.centerX.equalToSuperview()
            make.height.equalTo(Layout.waterGlassViewHeight)
        }
        
        //Bar chart view
        barChartView = ChartView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: Int(self.view.frame.width),
                                               height: Layout.barChartHeight),
                                 values: viewModel.pastWeekNumberOfGlasses)
        view.addSubview(barChartView)
        
        barChartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Layout.insets)
            make.height.equalTo(Layout.barChartHeight)
            let topInset = view.frame.maxY - barChartView.frame.maxY
            make.top.equalTo(waterGlassView.snp.bottom).offset(Layout.insets.top)
        }
                
        viewModel.incrementWaterSignal.observeValues { [weak self] (increment) in
            if increment {
                self?.barChartView.numberOfFilledGlassesForWeek.value = (self?.viewModel.pastWeekNumberOfGlasses)!
                self?.barChartView.barChartView.animate(yAxisDuration: 0.5)
            }
        }
        
        //Title label
        let titleLabel = UILabel().then {
            $0.text = titleString
            $0.font = UIFont.header
            $0.textColor = UIColor.waterBlue
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        
        //Navbar
        let navItem = UINavigationItem(title: "").then {
            $0.titleView = titleLabel
        }
        
        let navBar = UINavigationBar().then {
            $0.setItems([navItem], animated: false)
            $0.backgroundColor = .white
            $0.barTintColor = .white
            $0.setValue(true, forKey: "hidesShadow")
        }
        
        view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Layout.insets.top
            )
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func addHolderView(myView: UIView) {
        let holderView = HolderView(frame: CGRect.zero)
        holderViews.append(holderView)
        holderView.frame = CGRect(x: myView.bounds.width / 2 - 35,
                                  y: myView.bounds.width / 2 - 30,
                                  width: Layout.holderViewWidth,
                                  height: Layout.holderViewHeight)
        holderView.parentFrame = myView.frame
        holderView.delegate = self
        myView.addSubview(holderView)
        holderView.snp.makeConstraints { make in
            make.center.equalTo(myView)
            make.width.equalTo(Layout.holderViewWidth)
            make.height.equalTo(Layout.holderViewHeight)
        }
        holderView.drawBlueAnimatedRectangle()
    }
}

//MARK: - UICollectionViewDataSource and UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Layout.numberOfGlasses
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: waterGlassReuse, for: indexPath)
        addHolderView(myView: cell.contentView)
        
        if indexPath.row != 0 {
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !holderViews[indexPath.row].isFilled {
            holderViews[indexPath.row].drawArc()
            viewModel.incrementNumberOfGlasses()
            holderViews[indexPath.row].isFilled = true
            
            if indexPath.row != (Layout.numberOfGlasses - 1) {
                collectionView.cellForItem(at: IndexPath(row: indexPath.row + 1, section: 0))?.isUserInteractionEnabled = true
            }
        }
    }
    
    func refillGlassesWhenReopened() {
        let currentNumberOfFilledGlasses = viewModel.currentNumberOfFilledGlasses
        for i in 0..<Int(currentNumberOfFilledGlasses) {
            holderViews[i].drawArc()
            holderViews[i].isFilled = true
        }
        
        waterGlassView.cellForItem(at: IndexPath(row: Int(currentNumberOfFilledGlasses), section: 0))?.isUserInteractionEnabled = true
    }
}
