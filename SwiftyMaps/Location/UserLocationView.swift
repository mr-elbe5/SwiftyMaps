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
    
    static var baseFrame = CGRect(x: -MapStatics.locationRadius, y: -MapStatics.locationRadius, width: 2*MapStatics.locationRadius, height: 2*MapStatics.locationRadius)
    
    var state : LocationState = .none
    var planetPoint : CGPoint = .zero
    var direction : CLLocationDirection = 0
    
    init(){
        super.init(frame: UserLocationView.baseFrame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLocationPoint(planetPoint: CGPoint, offset: CGPoint, scale: CGFloat){
        self.planetPoint = planetPoint
        updatePosition(offset: offset, scale: scale)
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        let normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        let pnt = CGPoint(x: (planetPoint.x - normalizedOffset.point.x)*scale , y: (planetPoint.y - normalizedOffset.point.y)*scale)
        frame = UserLocationView.baseFrame.offsetBy(dx: pnt.x, dy: pnt.y)
        setNeedsDisplay()
    }
    
    func updateDirection(direction: CLLocationDirection){
        self.direction = direction
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        switch state{
        case .exact:
            let color = UserLocationView.userLocationColor.cgColor
            let ctx = UIGraphicsGetCurrentContext()!
            ctx.beginPath()
            ctx.addEllipse(in: rect.scaleCenteredBy(0.3))
            ctx.setFillColor(color)
            ctx.drawPath(using: .fill)
            ctx.beginPath()
            ctx.setLineWidth(2.0)
            ctx.addEllipse(in: rect.scaleCenteredBy(0.6))
            ctx.setStrokeColor(color)
            ctx.drawPath(using: .stroke)
            let angle1 = (direction - 15)*CGFloat.pi/180
            let angle2 = (direction + 15)*CGFloat.pi/180
            ctx.beginPath()
            ctx.setFillColor(UserLocationView.userDirectionColor.cgColor)
            let center = CGPoint(x: rect.midX, y: rect.midY)
            ctx.move(to: center)
            ctx.addLine(to: CGPoint(x: center.x + MapStatics.locationRadius * sin(angle1), y: center.y - MapStatics.locationRadius * cos(angle1)))
            ctx.addLine(to: CGPoint(x: center.x + MapStatics.locationRadius * sin(angle2), y: center.y - MapStatics.locationRadius * cos(angle2)))
            ctx.closePath()
            ctx.drawPath(using: .fill)
        case .estimated:
            let color = UserLocationView.userLocationColor.withAlphaComponent(0.2).cgColor
            let ctx = UIGraphicsGetCurrentContext()!
            ctx.setFillColor(color)
            ctx.addEllipse(in: rect)
            ctx.fillPath()
            return
        case .none:
            return
        }
    }
    
}
