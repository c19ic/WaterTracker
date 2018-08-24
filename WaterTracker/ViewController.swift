import UIKit
import Then
import SnapKit
import Charts

class ViewController: UIViewController {
    private var holderViews = [HolderView]()
    private var waterGlassView: UICollectionView!
    private let waterGlassReuse: String = "Glass"
    private let titleString: String = "got water?"
    private var barChartView: ChartView!
    
    var days = [String]()
    var numberOfFilledGlasses = [String]()
    
    private var viewModel: ViewModel!
    
    private enum Layout {
        static let numberOfGlasses = 8
        static let insets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        static let waterGlassViewHeight = 270
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
        let titleLabel = UILabel().then {
            $0.text = titleString
            $0.font = UIFont.header
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.centerX.equalToSuperview()
        }
        
        let layout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            $0.itemSize = CGSize(width: self.view.frame.width / 5.5, height: 115)
            $0.minimumLineSpacing = 15
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
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.insets.top)
            make.left.right.equalToSuperview().inset(Layout.insets)
            make.height.equalTo(Layout.waterGlassViewHeight)
        }
        
        barChartView = ChartView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: Int(self.view.frame.width),
                                               height: Layout.waterGlassViewHeight),
                                 values: viewModel.pastWeekNumberOfGlasses)
        
        view.addSubview(barChartView)
        
        barChartView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(waterGlassView.snp.bottom).inset(Layout.insets.top)
            make.bottom.equalToSuperview().inset(Layout.insets.bottom)
        }
    }
    
    private func addHolderView(myView: UIView) {
        let holderView = HolderView(frame: CGRect.zero)
        holderViews.append(holderView)
        holderView.frame = CGRect(x: myView.bounds.width / 2 - 35,
                                  y: myView.bounds.width / 2 - 30,
                                  width: 70,
                                  height: 100)
        holderView.parentFrame = myView.frame
        holderView.delegate = self
        myView.addSubview(holderView)
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
        for i in 0..<currentNumberOfFilledGlasses {
            holderViews[i].drawArc()
            holderViews[i].isFilled = true
        }
        
        waterGlassView.cellForItem(at: IndexPath(row: currentNumberOfFilledGlasses, section: 0))?.isUserInteractionEnabled = true
    }
}
