import UIKit

class RectangleLayer: CAShapeLayer {
    
    override init() {
        super.init()
        fillColor = UIColor.clear.cgColor
        lineWidth = 3
        path = cornerPath.cgPath
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cornerPath: UIBezierPath {
        let p = UIBezierPath()
//        UIColor.yellow.setStroke()
        let lineWidth : CGFloat = 3
        p.lineWidth = lineWidth
        // draw top left corner
        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine(to: CGPoint(x: 0, y: 93))
        p.addArc(withCenter: CGPoint(x: 5, y: 95),
                 radius: 5,
                 startAngle: CGFloat.pi,
                 endAngle: CGFloat.pi / 2,
                 clockwise: false)
        p.addLine(to:CGPoint(x: 65, y: 100))
        p.addArc(withCenter: CGPoint(x: 65, y: 95),
                 radius: 5,
                 startAngle: CGFloat.pi / 2,
                 endAngle: 0,
                 clockwise: false)
        p.addLine(to: CGPoint(x: 70, y: 0))
        return p
    }
    
    func animateStrokeWithColor(color: UIColor) {
        strokeColor = color.cgColor
        let strokeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.duration = 0.4
        add(strokeAnimation, forKey: nil)
    }
}


