//
//  TourViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 20.09.21.
//

import Foundation
import UIKit

protocol TourDelegate{
    func startTour()
    func stopTour()
}

class TourViewController: PopupViewController{
    
    var delegate : TourDelegate? = nil
    
    var currentTour : TourData? = nil
    
    var toggleTourButton = UIButton()
    
    override func loadView() {
        title = "tour".localize()
        super.loadView()
        currentTour = TourData.activeTour
        
        toggleTourButton.setTitleColor(.systemBlue, for: .normal)
        toggleTourButton.addTarget(self, action: #selector(toggleTour), for: .touchDown)
        contentView.addSubview(toggleTourButton)
        toggleTourButton.setAnchors(top: contentView.topAnchor, bottom: contentView.bottomAnchor, insets: Insets.doubleInsets)
            .centerX(contentView.centerXAnchor)
        updateToggleButton()
        
    }
    
    func updateToggleButton(){
        if currentTour == nil{
            toggleTourButton.setTitle("startTour".localize(), for: .normal)
        }
        else{
            toggleTourButton.setTitle("stopTour".localize(), for: .normal)
        }
    }
    
    @objc func toggleTour(){
        if currentTour == nil{
            delegate?.startTour()
        }
        else{
            delegate?.stopTour()
        }
        currentTour = TourData.activeTour
        updateToggleButton()
    }
    
}
