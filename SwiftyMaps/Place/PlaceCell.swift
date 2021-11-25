//
//  PlaceCell.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.11.21.
//

import UIKit


protocol PlaceCellActionDelegate{
    func editPlace(place: PlaceData)
    func deletePlace(place: PlaceData)
    func viewPlace(place: PlaceData)
    func showOnMap(place: PlaceData)
}

class PlaceCell: UITableViewCell{
    
    var place : PlaceData? = nil {
        didSet {
            updateCell()
        }
    }
    
    var delegate: PlaceCellActionDelegate? = nil
    
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
        if let place = place{
            var nextAnchor : NSLayoutYAxisAnchor!
            if isEditing{
                let deleteButton = IconButton(icon: "xmark.circle")
                deleteButton.tintColor = UIColor.systemRed
                deleteButton.addTarget(self, action: #selector(deletePlace), for: .touchDown)
                cellBody.addSubview(deleteButton)
                deleteButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                
                let editButton = IconButton(icon: "pencil.circle")
                editButton.tintColor = UIColor.systemBlue
                editButton.addTarget(self, action: #selector(editPlace), for: .touchDown)
                cellBody.addSubview(editButton)
                editButton.setAnchors(top: cellBody.topAnchor, trailing: deleteButton.leadingAnchor, insets: defaultInsets)
                
                nextAnchor = editButton.bottomAnchor
            }
            else{
                let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
                viewButton.addTarget(self, action: #selector(viewPlace), for: .touchDown)
                cellBody.addSubview(viewButton)
                viewButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                
                let mapButton = IconButton(icon: "mappin")
                mapButton.tintColor = UIColor.systemBlue
                mapButton.addTarget(self, action: #selector(showOnMap), for: .touchDown)
                cellBody.addSubview(mapButton)
                mapButton.setAnchors(top: cellBody.topAnchor, trailing: viewButton.leadingAnchor, insets: defaultInsets)
                
                nextAnchor = mapButton.bottomAnchor
            }
            var label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.text = place.locationString
            cellBody.addSubview(label)
            label.setAnchors(top: nextAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            nextAnchor = label.bottomAnchor
            label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.text = place.coordinateString
            cellBody.addSubview(label)
            label.setAnchors(top: nextAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            nextAnchor = label.bottomAnchor
            if !description.isEmpty{
                label = UILabel()
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
                label.text = place.description
                cellBody.addSubview(label)
                label.setAnchors(top: nextAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                nextAnchor = label.bottomAnchor
            }
            label = UILabel()
            label.text = String(place.photos.count) + " " + "photos".localize()
            cellBody.addSubview(label)
            label.setAnchors(top: nextAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, bottom: cellBody.bottomAnchor, insets: defaultInsets)
        }
    }
    
    @objc func editPlace() {
        if let place = place{
            delegate?.editPlace(place: place)
        }
    }
    
    @objc func deletePlace() {
        if let place = place{
            delegate?.deletePlace(place: place)
        }
    }
    
    @objc func viewPlace(){
        if place != nil{
            delegate?.viewPlace(place: place!)
        }
    }
    
    @objc func showOnMap(){
        if place != nil{
            delegate?.showOnMap(place: place!)
        }
    }
    
}


