//
//  MapTrackingView.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 16.11.21.
//

import UIKit
import CoreLocation

class TrackLayerView: UIView {
    
    var locationPoint : CGPoint = .zero
    
    init(){
        super.init(frame: UserLocationView.baseFrame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLocation(location: CGPoint, offset: CGPoint, scale: CGFloat){
        locationPoint = location
        updatePosition(offset: offset, scale: scale)
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        let normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        let pnt = CGPoint(x: (locationPoint.x - normalizedOffset.point.x)*scale , y: (locationPoint.y - normalizedOffset.point.y)*scale)
        frame = UserLocationView.baseFrame.offsetBy(dx: pnt.x, dy: pnt.y)
    }
    
    override func draw(_ rect: CGRect) {
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
    }
    
}


