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
    
    init(){
    }
    
    func fillLicenseView(_ view: UIView){
        
    }

}

class CartoMapType : MapType{
    
    static var defaultUrl = "https://maps.elbe5.de/carto/{z}/{x}/{y}.png"
    
    override var maxZoom : Int{get{18}}
    override var name : String{get{"carto"}}
    
    
    override init(){
        super.init()
        tileUrl = CartoMapType.defaultUrl
        
    }
    
    override func fillLicenseView(_ view: UIView){
        view.removeAllSubviews()
        var label = UILabel()
        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .footnote)
        view.addSubview(label)
        label.setAnchors(top: view.topAnchor, leading: view.leadingAnchor, trailing: nil, bottom: view.bottomAnchor, insets: .zero)
        label.text = "© "
        let link = UIButton()
        link.setTitleColor(.systemBlue, for: .normal)
        link.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        view.addSubview(link)
        link.setAnchors(top: view.topAnchor, leading: label.trailingAnchor, trailing: nil, bottom: view.bottomAnchor, insets: .zero)
        link.setTitle("OpenStreetMap", for: .normal)
        link.addTarget(self, action: #selector(openOSMUrl), for: .touchDown)
        label = UILabel()
        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .footnote)
        view.addSubview(label)
        label.setAnchors(top: view.topAnchor, leading: link.trailingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Insets.defaultInset))
        label.text = " contributors"
    }
    
    @objc func openOSMUrl() {
        UIApplication.shared.open(URL(string: "https://www.openstreetmap.org/copyright")!)
    }
}

class TopoMapType : MapType{
    
    static var defaultUrl = "https://a.tile.opentopomap.org/{z}/{x}/{y}.png"
    
    override var maxZoom : Int{get{17}}
    override var name : String{get{"topo"}}
    
    override init(){
        super.init()
        tileUrl = TopoMapType.defaultUrl
    }
    
    override func fillLicenseView(_ view: UIView){
        view.removeAllSubviews()
        var label = UILabel()
        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .footnote)
        view.addSubview(label)
        label.setAnchors(top: view.topAnchor, leading: view.leadingAnchor, trailing: nil, bottom: view.bottomAnchor, insets: .zero)
        label.text = "Data: © "
        var link = UIButton()
        link.setTitleColor(.systemBlue, for: .normal)
        link.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        view.addSubview(link)
        link.setAnchors(top: view.topAnchor, leading: label.trailingAnchor, trailing: nil, bottom: view.bottomAnchor, insets: .zero)
        link.setTitle("OpenStreetMap", for: .normal)
        link.addTarget(self, action: #selector(openOSMUrl), for: .touchDown)
        label = UILabel()
        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .footnote)
        view.addSubview(label)
        label.setAnchors(top: view.topAnchor, leading: link.trailingAnchor, trailing: nil, bottom: view.bottomAnchor, insets: .zero)
        label.text = " contributors, Layout: © "
        link = UIButton()
        link.setTitleColor(.systemBlue, for: .normal)
        link.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        view.addSubview(link)
        link.setAnchors(top: view.topAnchor, leading: label.trailingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Insets.defaultInset))
        link.setTitle("OpenTopoMap", for: .normal)
        link.addTarget(self, action: #selector(openTopoUrl), for: .touchDown)
    }
    
    @objc func openOSMUrl() {
        UIApplication.shared.open(URL(string: "https://www.openstreetmap.org/copyright")!)
    }
        
    @objc func openTopoUrl() {
        UIApplication.shared.open(URL(string: "https://opentopomap.org")!)
    }
    
}



