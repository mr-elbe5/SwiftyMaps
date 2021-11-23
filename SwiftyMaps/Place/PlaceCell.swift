//
//  PlaceCell.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.11.21.
//

import UIKit


protocol PlaceCellActionDelegate{
    func deletePlace(place: PlaceData)
    func viewPlace(place: PlaceData)
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
        cellBody.fillView(view: contentView, insets: Insets.defaultInsets)
        accessoryType = .none
        updateCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isEditing: Bool = false){
        cellBody.removeAllSubviews()
        if place != nil{
            var nextAnchor : NSLayoutYAxisAnchor!
            if isEditing{
                let deleteButton = IconButton(icon: "xmark.circle")
                deleteButton.tintColor = UIColor.systemRed
                deleteButton.addTarget(self, action: #selector(deletePlace), for: .touchDown)
                cellBody.addSubview(deleteButton)
                deleteButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: Insets.defaultInsets)
                nextAnchor = deleteButton.bottomAnchor
            }
            else{
                let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
                viewButton.addTarget(self, action: #selector(viewPlace), for: .touchDown)
                cellBody.addSubview(viewButton)
                viewButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: Insets.defaultInsets)
                nextAnchor = viewButton.bottomAnchor
            }
            let vw = UILabel()
            var text = place!.description
            if text.isEmpty{
                text = "noDescription".localize()
            }
            vw.text = text
            cellBody.addSubview(vw)
            vw.setAnchors(top: nextAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, bottom: cellBody.bottomAnchor, insets: defaultInsets)
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
    
}


