//
// Created by Michael Rönnau on 14.09.21.
//

import Foundation
import UIKit

class MapType{
    
    static var carto = CartoMapType()
    static var topo = TopoMapType()
    static var current : MapType = carto
    
    static func getMapType(name: String) -> MapType?{
        switch name{
        case "carto" : return carto
        case "topo": return topo
        default: return nil
        }
    }
    
    var maxZoom : Int{get{0}}
    var name : String{get{""}}
    var tileUrl: String = ""
    
    var licenseLink = UIView()
    
    init(){
    }
    
    @objc func openOSMUrl() {
        UIApplication.shared.open(URL(string: "https://www.openstreetmap.org/copyright")!)
    }

}

class CartoMapType : MapType{
    
    static var defaultUrl = "https://maps.elbe5.de/carto/{z}/{x}/{y}.png"
    
    override var maxZoom : Int{get{18}}
    override var name : String{get{"carto"}}
    
    
    override init(){
        super.init()
        tileUrl = CartoMapType.defaultUrl
        /*let label = UIButton()
        licenseLink.addSubview(label)
        label.fillView(view: self)
        label.setTitle("Map data: © OpenStreetMap contributors", for: .normal)
        label.addTarget(self, action: #selector(openOSMUrl), for: .touchDown)*/
    }
}

class TopoMapType : MapType{
    
    static var defaultUrl = "https://a.tile.opentopomap.org/{z}/{x}/{y}.png"
    
    override var maxZoom : Int{get{17}}
    override var name : String{get{"topo"}}
    
    override init(){
        super.init()
        tileUrl = TopoMapType.defaultUrl
        /*let label = UIButton()
        licenseLink.addSubview(label)
        label.fillView(view: licenseLink)
        label.setTitle("Kartendaten: © OpenStreetMap-Mitwirkende, SRTM | Kartendarstellung: © OpenTopoMap (CC-BY-SA)", for: .normal)
        label.addTarget(self, action: #selector(openTopoUrl), for: .touchDown)*/
    }
        
    @objc func openTopoUrl() {
        UIApplication.shared.open(URL(string: "https://opentopomap.org")!)
    }
    
}



