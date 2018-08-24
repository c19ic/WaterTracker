import UIKit

protocol HolderViewDelegate:class {
}

class HolderView: UIView {
    
    let blueRectangleLayer = RectangleLayer()
    let arcLayer = ArcLayer()
    var isFilled : Bool = false
    var parentFrame :CGRect = CGRect.zero
    weak var delegate:HolderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    @objc func drawBlueAnimatedRectangle() {
        layer.addSublayer(blueRectangleLayer)
        blueRectangleLayer.animateStrokeWithColor(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    @objc func drawArc() {
        layer.insertSublayer(arcLayer, at: 0)
        arcLayer.animate()
    }
    
}


