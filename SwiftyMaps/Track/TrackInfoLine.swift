//
//  TrackInfoLine.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 24.11.21.
//

import Foundation
import UIKit

class TrackInfoLine : UIView{
    
    var distanceLabel = UILabel()
    var distanceUpLabel = UILabel()
    var distanceDownLabel = UILabel()
    var timeLabel = UILabel()
    
    var timer : Timer? = nil
    
    func setup(){
        backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        let distanceIcon = UIImageView(image: UIImage(systemName: "arrow.right"))
        distanceIcon.tintColor = .darkGray
        addSubview(distanceIcon)
        distanceIcon.setAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: flatInsets)
        distanceLabel.textColor = .darkGray
        addSubview(distanceLabel)
        distanceLabel.setAnchors(top: topAnchor, leading: distanceIcon.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        
        let distanceUpIcon = UIImageView(image: UIImage(systemName: "arrow.up"))
        distanceUpIcon.tintColor = .darkGray
        addSubview(distanceUpIcon)
        distanceUpIcon.setAnchors(top: topAnchor, leading: distanceLabel.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        distanceUpLabel.textColor = .darkGray
        addSubview(distanceUpLabel)
        distanceUpLabel.setAnchors(top: topAnchor, leading: distanceUpIcon.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        
        let distanceDownIcon = UIImageView(image: UIImage(systemName: "arrow.down"))
        distanceDownIcon.tintColor = .darkGray
        addSubview(distanceDownIcon)
        distanceDownIcon.setAnchors(top: topAnchor, leading: distanceUpLabel.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        distanceDownLabel.textColor = .darkGray
        addSubview(distanceDownLabel)
        distanceDownLabel.setAnchors(top: topAnchor, leading: distanceDownIcon.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        
        let timeIcon = UIImageView(image: UIImage(systemName: "stopwatch"))
        timeIcon.tintColor = .darkGray
        addSubview(timeIcon)
        timeIcon.setAnchors(top: topAnchor, leading: distanceDownLabel.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        timeLabel.textColor = .darkGray
        addSubview(timeLabel)
        timeLabel.setAnchors(top: topAnchor, leading: timeIcon.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        
        self.isHidden = true
    }
    
    func startInfo(){
        self.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func updateInfo(){
        if let track = Tracks.instance.activeTrack{
            distanceLabel.text = "\(Int(track.distance))m"
            distanceUpLabel.text = "\(Int(track.upDistance))m"
            distanceDownLabel.text = "\(Int(track.downDistance))m"
        }
    }
    
    func stopInfo(){
        self.isHidden = true
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateTime(){
        if let track = Tracks.instance.activeTrack{
            let interval = track.startTime.distance(to: Date())
            timeLabel.text = interval.hmsString()
        }
    }
    
}
