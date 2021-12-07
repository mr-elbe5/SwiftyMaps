/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit


protocol LocationCellDelegate{
    func editLocation(location: Location)
    func deleteLocation(location: Location, approved: Bool)
    func viewLocation(location: Location)
    func showOnMap(location: Location)
}

class LocationCell: UITableViewCell{
    
    var location : Location? = nil {
        didSet {
            updateCell()
        }
    }
    
    var delegate: LocationCellDelegate? = nil
    
    var cellBody = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        backgroundColor = .clear
        shouldIndentWhileEditing = false
        cellBody.backgroundColor = .white
        cellBody.layer.cornerRadius = 5
        contentView.addSubview(cellBody)
        cellBody.fillView(view: contentView, insets: defaultInsets)
        accessoryType = .none
        updateCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isEditing: Bool = false){
        cellBody.removeAllSubviews()
        if let location = location{
            var nextAnchor : NSLayoutYAxisAnchor!
            if isEditing{
                let deleteButton = IconButton(icon: "xmark.circle")
                deleteButton.tintColor = UIColor.systemRed
                deleteButton.addTarget(self, action: #selector(deleteLocation), for: .touchDown)
                cellBody.addSubview(deleteButton)
                deleteButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                
                let editButton = IconButton(icon: "pencil.circle")
                editButton.tintColor = UIColor.systemBlue
                editButton.addTarget(self, action: #selector(editLocation), for: .touchDown)
                cellBody.addSubview(editButton)
                editButton.setAnchors(top: cellBody.topAnchor, trailing: deleteButton.leadingAnchor, insets: defaultInsets)
                
                nextAnchor = editButton.bottomAnchor
            }
            else{
                let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
                viewButton.addTarget(self, action: #selector(viewLocation), for: .touchDown)
                cellBody.addSubview(viewButton)
                viewButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                
                let mapButton = IconButton(icon: "map")
                mapButton.tintColor = UIColor.systemBlue
                mapButton.addTarget(self, action: #selector(showOnMap), for: .touchDown)
                cellBody.addSubview(mapButton)
                mapButton.setAnchors(top: cellBody.topAnchor, trailing: viewButton.leadingAnchor, insets: defaultInsets)
                
                nextAnchor = mapButton.bottomAnchor
            }
            var label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.text = location.locationString
            cellBody.addSubview(label)
            label.setAnchors(top: nextAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            nextAnchor = label.bottomAnchor
            label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.text = location.coordinateString
            cellBody.addSubview(label)
            label.setAnchors(top: nextAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            nextAnchor = label.bottomAnchor
            if !description.isEmpty{
                label = UILabel()
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
                label.text = location.description
                cellBody.addSubview(label)
                label.setAnchors(top: nextAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                nextAnchor = label.bottomAnchor
            }
            label = UILabel()
            label.text = String(location.photos.count) + " " + "photos".localize()
            cellBody.addSubview(label)
            label.setAnchors(top: nextAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            nextAnchor = label.bottomAnchor
            label = UILabel()
            label.text = String(location.tracks.count) + " " + "tracks".localize()
            cellBody.addSubview(label)
            label.setAnchors(top: nextAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, bottom: cellBody.bottomAnchor, insets: defaultInsets)
        }
    }
    
    @objc func editLocation() {
        if let location = location{
            delegate?.editLocation(location: location)
        }
    }
    
    @objc func deleteLocation() {
        if let location = location{
            delegate?.deleteLocation(location: location, approved: false)
        }
    }
    
    @objc func viewLocation(){
        if location != nil{
            delegate?.viewLocation(location: location!)
        }
    }
    
    @objc func showOnMap(){
        if location != nil{
            delegate?.showOnMap(location: location!)
        }
    }
    
}


