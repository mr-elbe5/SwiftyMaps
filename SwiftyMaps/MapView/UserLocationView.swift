/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import CoreLocation

class UserLocationView : UIView{
    
    static var userLocationColor = UIColor.systemBlue
    static var userDirectionColor = UIColor.red
    
    static var goodPositionColor = UIColor(red: 0.0, green: 0, blue: 1.0, alpha: 1.0).cgColor
    static var mediumPositionColor = UIColor(red: 0.75, green: 0, blue: 1.0, alpha: 1.0).cgColor
    static var badPositionColor = UIColor(red: 1.0, green: 0, blue: 1.0, alpha: 1.0).cgColor
    
    var drawCenter : CGPoint? = nil
    var accuracy: CLLocationAccuracy = 100
    var planetPoint : CGPoint = .zero
    var heading : Int = 0
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
    func updateLocationPoint(planetPoint: CGPoint, accuracy: CLLocationAccuracy, offset: CGPoint, scale: CGFloat){
        self.planetPoint = planetPoint
        self.accuracy = accuracy
        updatePosition(offset: offset, scale: scale)
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        let normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        drawCenter = CGPoint(x: (planetPoint.x - normalizedOffset.point.x)*scale , y: (planetPoint.y - normalizedOffset.point.y)*scale)
        setNeedsDisplay()
    }
    
    func updateDirection(heading: Int){
        self.heading = heading
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if let drawCenter = drawCenter{
            let drawRect = CGRect(x: drawCenter.x - MapStatics.locationRadius , y: drawCenter.y - MapStatics.locationRadius, width: 2*MapStatics.locationRadius, height: 2*MapStatics.locationRadius)
            let ctx = UIGraphicsGetCurrentContext()!
            var color : CGColor!
            if accuracy <= 10{
                color = UserLocationView.goodPositionColor
            }
            else if accuracy <= 50{
                color = UserLocationView.mediumPositionColor
            }
            else{
                color = UserLocationView.badPositionColor
            }
            ctx.beginPath()
            ctx.addEllipse(in: drawRect.scaleCenteredBy(0.3))
            ctx.setFillColor(color)
            ctx.drawPath(using: .fill)
            ctx.beginPath()
            ctx.setLineWidth(2.0)
            ctx.addEllipse(in: drawRect.scaleCenteredBy(0.6))
            ctx.setStrokeColor(color)
            ctx.drawPath(using: .stroke)
            let angle1 = (Double(heading) - 15.0)*CGFloat.pi/180
            let sin1 = sin(angle1)
            let angle2 = (Double(heading) + 15.0)*CGFloat.pi/180
            let sin2 = sin(angle2)
            ctx.beginPath()
            ctx.setFillColor(UserLocationView.userDirectionColor.cgColor)
            ctx.move(to: drawCenter)
            ctx.addLine(to: CGPoint(x: drawCenter.x + MapStatics.locationRadius * sin1, y: drawCenter.y - MapStatics.locationRadius * cos(angle1)))
            ctx.addLine(to: CGPoint(x: drawCenter.x + MapStatics.locationRadius * sin2, y: drawCenter.y - MapStatics.locationRadius * cos(angle2)))
            ctx.closePath()
            ctx.drawPath(using: .fill)
        }
    }
    
}

