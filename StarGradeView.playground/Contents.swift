//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

enum ReviewStarStyle { case full, half, empty }

class StarGradeView: UIView {
    init(grade: CGFloat, aspect: CGFloat, space: CGFloat = 0) {
        super.init(frame: CGRect(x: 0, y: 0, width: aspect*5 + space*4, height: aspect))
        self.backgroundColor = .clear
        
        var starPositionX: CGFloat = 0
        let remain = grade - CGFloat(Int(grade))
        
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer()}
        
        (0..<Int(grade)).forEach { _ in
            self.layer.addSublayer(CAShapeLayer(style: .full, origin: CGPoint(x: starPositionX, y: 0), aspect: aspect))
            starPositionX += (aspect + space)
        }
        
        if (remain >= 0.5) {
            let emptyLayer = CAShapeLayer(style: .empty, origin: CGPoint(x: starPositionX, y: 0), aspect: aspect)
            self.layer.addSublayer(emptyLayer)
            self.layer.addSublayer(CAShapeLayer(style: .half, origin: CGPoint(x: starPositionX, y: 0), aspect: aspect))
            starPositionX += (aspect + space)
        }
        
        (Int(grade + remain)..<5).forEach { _ in
            self.layer.addSublayer(CAShapeLayer(style: .empty, origin: CGPoint(x: starPositionX, y: 0), aspect: aspect))
            starPositionX += (aspect + space)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CAShapeLayer {
    convenience init(style: ReviewStarStyle, origin: CGPoint, aspect: CGFloat) {
        self.init()
        
        var path = UIBezierPath()
        var origin = origin
        var size = CGSize(width: aspect, height: aspect)
        
        switch style {
        case .full:
            path = UIBezierPath(starIn: CGRect(origin: origin, size: size))
            break
        case .half:
            let halfLayer = CAShapeLayer(style: .empty, origin: origin, aspect: aspect)
            self.addSublayer(halfLayer)
            
            path = UIBezierPath(starHalfIn: CGRect(origin: origin, size: size))
            break
        case .empty:
            origin = CGPoint(x: origin.x + aspect * 0.03, y: origin.y + aspect * 0.04)
            size = CGSize(width: aspect * 0.94, height: aspect * 0.94)
            path = UIBezierPath(starIn: CGRect(origin: origin, size: size))
            break
        }
        
        self.path = path.cgPath
        self.strokeColor = UIColor.black.cgColor
        self.fillColor = style == .empty ? UIColor.clear.cgColor : UIColor.black.cgColor
        self.lineWidth = style == .empty ? aspect * 0.04 : 1
//        self.opacity = 0.4    // for debugging
    }
}


extension UIBezierPath {
    convenience init(starIn rect: CGRect) {
        self.init()
        
        let headPoint = CGPoint(x: rect.origin.x + rect.size.width * 0.5, y: rect.origin.y)
        
        let leftPoint1 = CGPoint(x: rect.origin.x + rect.size.width * 0.65,
                                 y: rect.origin.y + rect.size.height * 0.33)
        let leftPoint2 = CGPoint(x: rect.origin.x + rect.size.width * 1,
                                 y: rect.origin.y + rect.size.height * 0.38)
        let leftPoint3 = CGPoint(x: rect.origin.x + rect.size.width * 0.75,
                                 y: rect.origin.y + rect.size.height * 0.63)
        let leftPoint4 = CGPoint(x: rect.origin.x + rect.size.width * 0.81,
                                 y: rect.origin.y + rect.size.height * 1)
        
        let tailPoint = CGPoint(x: rect.origin.x + rect.size.width * 0.5,
                                y: rect.origin.y + rect.size.width * 0.82)
        
        let rightPoint1 = CGPoint(x: rect.origin.x + rect.size.width * 0.35,
                                  y: rect.origin.y + rect.size.height * 0.33)
        let rightPoint2 = CGPoint(x: rect.origin.x + rect.size.width * 0,
                                  y: rect.origin.y + rect.size.height * 0.38)
        let rightPoint3 = CGPoint(x: rect.origin.x + rect.size.width * 0.25,
                                  y: rect.origin.y + rect.size.height * 0.63)
        let rightPoint4 = CGPoint(x: rect.origin.x + rect.size.width * 0.19,
                                  y: rect.origin.y + rect.size.height * 1)
        
        self.move(to: headPoint)
        self.addLine(to: leftPoint1)
        self.addLine(to: leftPoint2)
        self.addLine(to: leftPoint3)
        self.addLine(to: leftPoint4)
        self.addLine(to: tailPoint)
        self.addLine(to: rightPoint4)
        self.addLine(to: rightPoint3)
        self.addLine(to: rightPoint2)
        self.addLine(to: rightPoint1)
        self.close()
    }
    
    convenience init(starHalfIn rect: CGRect) {
        self.init()
        
        let headPoint = CGPoint(x: rect.origin.x + rect.size.width * 0.5, y: rect.origin.y)
        
        let tailPoint = CGPoint(x: rect.origin.x + rect.size.width * 0.5,
                                y: rect.origin.y + rect.size.width * 0.82)
        
        let rightPoint1 = CGPoint(x: rect.origin.x + rect.size.width * 0.35,
                                  y: rect.origin.y + rect.size.height * 0.33)
        let rightPoint2 = CGPoint(x: rect.origin.x + rect.size.width * 0,
                                  y: rect.origin.y + rect.size.height * 0.38)
        let rightPoint3 = CGPoint(x: rect.origin.x + rect.size.width * 0.25,
                                  y: rect.origin.y + rect.size.height * 0.63)
        let rightPoint4 = CGPoint(x: rect.origin.x + rect.size.width * 0.19,
                                  y: rect.origin.y + rect.size.height * 1)
        
        self.move(to: headPoint)
        self.addLine(to: tailPoint)
        self.addLine(to: rightPoint4)
        self.addLine(to: rightPoint3)
        self.addLine(to: rightPoint2)
        self.addLine(to: rightPoint1)
        self.close()
    }
}


class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let aspect: CGFloat = 50
        let space: CGFloat = 10
        let gradeView = StarGradeView(grade: 3.6, aspect: aspect, space: space)
        gradeView.frame = CGRect(x: 17, y: 100, width: aspect*5 + space*4, height: aspect)
        view.addSubview(gradeView)
        
        self.view = view
    }
}

PlaygroundPage.current.liveView = MyViewController()
