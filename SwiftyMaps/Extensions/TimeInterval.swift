//
//  TimeInterval.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 24.11.21.
//

import Foundation

extension TimeInterval{
    
    func hmsString() -> String {
        
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
}
