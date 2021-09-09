//
//  AVCaptureDevice.swift
//
//  Created by Michael Rönnau on 27.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension AVCaptureDevice {
    
    static func askCameraAuthorization(callback: @escaping (Result<Void, Error>) -> Void){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            callback(.success(()))
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ granted in
                if granted{
                    callback(.success(()))
                }
                else{
                    callback(.failure(AuthorizationError.rejected))
                }
            }
            break
        default:
            callback(.failure(AuthorizationError.rejected))
            break
        }
    }
    
}


extension AVCaptureDevice.DiscoverySession {
    
    var uniqueDevicePositionsCount: Int {
        
        var uniqueDevicePositions = [AVCaptureDevice.Position]()
        
        for device in devices where !uniqueDevicePositions.contains(device.position) {
            uniqueDevicePositions.append(device.position)
        }
        
        return uniqueDevicePositions.count
    }
    
}
