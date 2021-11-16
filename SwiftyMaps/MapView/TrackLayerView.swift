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
    
    init(){
        super.init(frame: UserLocationView.baseFrame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTrack(_ location: CLLocation){
        if let tour = tour{
            tour.updateTrack(location)
        }
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


