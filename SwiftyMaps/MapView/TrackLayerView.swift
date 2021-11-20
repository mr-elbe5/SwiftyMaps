//
//  MapTrackingView.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 16.11.21.
//

import UIKit
import CoreLocation

class TrackLayerView: UIView {
    
    var tour : TourData? = nil
    
    var offset = CGPoint()
    var scale : CGFloat = 1.0
    var normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint())
    
    init(){
        super.init(frame: UserLocationView.baseFrame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
    func updateTrack(_ location: CLLocation){
        if let tour = tour{
            tour.updateTrack(location)
        }
    }
    
    func updatePosition(offset: CGPoint, scale: CGFloat){
        self.offset = offset
        self.scale = scale
        normalizedOffset = NormalizedPlanetPoint(pnt: CGPoint(x: offset.x/scale, y: offset.y/scale))
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if let tour = TourData.activeTour{
            if !tour.trackpoints.isEmpty{
                let color = UIColor.systemOrange.cgColor
                let ctx = UIGraphicsGetCurrentContext()!
                ctx.beginPath()
                ctx.move(to: getPoint(tour.trackpoints[0]))
                for idx in 1..<tour.trackpoints.count{
                    ctx.addLine(to: getPoint(tour.trackpoints[idx]))
                }
                ctx.setStrokeColor(color)
                ctx.setLineWidth(4.0)
                ctx.drawPath(using: .stroke)
            }
        }
    }
    
    func getPoint(_ trackPoint: TrackPoint) -> CGPoint{
        let locationPoint = MapCalculator.planetPointFromCoordinate(coordinate: trackPoint.coordinate)
        return CGPoint(x: (locationPoint.x - normalizedOffset.point.x)*scale , y: (locationPoint.y - normalizedOffset.point.y)*scale)
    }
    
}


