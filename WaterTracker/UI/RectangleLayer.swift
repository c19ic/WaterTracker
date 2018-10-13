import UIKit

class RectangleLayer: CAShapeLayer {
    
    let height: CGFloat = 100
    let width: CGFloat = 60
    let radius: CGFloat = 5
    let x: CGFloat = 0
    let y: CGFloat = 0
    
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
        let lineWidth : CGFloat = radius
        p.lineWidth = lineWidth
        // draw top left corner
        p.move(to: CGPoint(x: x, y: y))
        p.addLine(to: CGPoint(x: x, y: height - radius))
        p.addArc(withCenter: CGPoint(x: radius, y: height - radius),
                 radius: radius,
                 startAngle: CGFloat.pi,
                 endAngle: CGFloat.pi / 2,
                 clockwise: false)
        p.addLine(to:CGPoint(x: width - radius, y: height))
        p.addArc(withCenter: CGPoint(x: width - radius, y: height - radius),
                 radius: radius,
                 startAngle: CGFloat.pi / 2,
                 endAngle: 0,
                 clockwise: false)
        p.addLine(to: CGPoint(x: width, y: 0))
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


