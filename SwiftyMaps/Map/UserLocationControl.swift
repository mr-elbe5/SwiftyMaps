//
//  LocationView.swift
//  OSM-Maps
//
//  Created by Michael Rönnau on 30.10.21.
//

import UIKit
import CoreLocation

protocol UserLocationDelegate{
    func addUserLocationAnnotation()
}

class UserLocationControl : UIButton{
    
    static var baseFrame = CGRect(x: -MapStatics.locationRadius, y: -MapStatics.locationRadius, width: 2*MapStatics.locationRadius, height: 2*MapStatics.locationRadius)
    
    var locationPoint : CGPoint = .zero
    var direction : CLLocationDirection = 0
    
    var delegate : UserLocationDelegate? = nil
    
    init(){
        super.init(frame: UserLocationControl.baseFrame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createMenu(){
        let addAnnotationAction = UIAction(title: "Add annotation", image: UIImage(systemName: "mappin")){ action in
            self.delegate?.addUserLocationAnnotation()
        }
        menu = UIMenu(title: "", image: nil, children: [addAnnotationAction])
        showsMenuAsPrimaryAction = true
    }
    
    func updateLocation(location: CGPoint, offset: CGPoint, scale: CGFloat){
        locationPoint = location
        updatePosition(offset: offset, scale: scale)
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        let normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        let pnt = CGPoint(x: (locationPoint.x - normalizedOffset.point.x)*scale , y: (locationPoint.y - normalizedOffset.point.y)*scale)
        frame = UserLocationControl.baseFrame.offsetBy(dx: pnt.x, dy: pnt.y)
    }
    
    func updateDirection(direction: CLLocationDirection){
        self.direction = direction
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        //MapStatics.directionImage?.draw(in: rect)
        let color = UIColor.systemBlue.cgColor
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.beginPath()
        ctx.addEllipse(in: rect.scaleCenteredBy(0.4))
        ctx.setFillColor(color)
        ctx.drawPath(using: .fill)
        ctx.beginPath()
        ctx.setLineWidth(2.0)
        ctx.addEllipse(in: rect.scaleCenteredBy(0.7))
        ctx.setStrokeColor(color)
        ctx.drawPath(using: .stroke)
        if Preferences.instance.showUserDirection{
            //print("direction= \(direction)")
            let angle1 = (direction - 15)*CGFloat.pi/180
            let angle2 = (direction + 15)*CGFloat.pi/180
            ctx.beginPath()
            ctx.setFillColor(UIColor.red.cgColor)
            let center = CGPoint(x: rect.midX, y: rect.midY)
            ctx.move(to: center)
            ctx.addLine(to: CGPoint(x: center.x + MapStatics.locationRadius * sin(angle1), y: center.y - MapStatics.locationRadius * cos(angle1)))
            ctx.addLine(to: CGPoint(x: center.x + MapStatics.locationRadius * sin(angle2), y: center.y - MapStatics.locationRadius * cos(angle2)))
            ctx.closePath()
            ctx.drawPath(using: .fill)
        }
    }
    
}
