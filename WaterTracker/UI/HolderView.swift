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
        blueRectangleLayer.animateStrokeWithColor(color: UIColor.dark)
    }
    
    @objc func drawArc() {
        layer.insertSublayer(arcLayer, at: 0)
        arcLayer.animate()
    }
    
}


