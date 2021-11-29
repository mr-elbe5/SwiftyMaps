/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit


protocol TrackCellActionDelegate{
    func deleteTrack(track: TrackData)
    func viewTrack(track: TrackData)
    func showOnMap(track: TrackData)
}

class TrackCell: UITableViewCell{
    
    var track : TrackData? = nil {
        didSet {
            updateCell()
        }
    }
    
    var delegate: TrackCellActionDelegate? = nil
    
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
        if let track = track{
            if isEditing{
                let deleteButton = IconButton(icon: "xmark.circle")
                deleteButton.tintColor = UIColor.systemRed
                deleteButton.addTarget(self, action: #selector(deleteTrack), for: .touchDown)
                cellBody.addSubview(deleteButton)
                deleteButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            }
            else{
                let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
                viewButton.addTarget(self, action: #selector(viewTrack), for: .touchDown)
                cellBody.addSubview(viewButton)
                viewButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                
                let mapButton = IconButton(icon: "map")
                mapButton.tintColor = UIColor.systemBlue
                mapButton.addTarget(self, action: #selector(showOnMap), for: .touchDown)
                cellBody.addSubview(mapButton)
                mapButton.setAnchors(top: cellBody.topAnchor, trailing: viewButton.leadingAnchor, insets: defaultInsets)
            }
            let nameLabel = UILabel()
            nameLabel.text = track.description
            cellBody.addSubview(nameLabel)
            nameLabel.setAnchors(top: cellBody.topAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: UIEdgeInsets(top: 2*defaultInset, left: defaultInset, bottom: defaultInset, right: defaultInset))
            let timeLabel = UILabel()
            timeLabel.text = "\(track.startTime.dateTimeString()) - \(track.endTime.dateTimeString())"
            cellBody.addSubview(timeLabel)
            timeLabel.setAnchors(top: nameLabel.bottomAnchor, leading: cellBody.leadingAnchor, insets: defaultInsets)
            let locationLabel = UILabel()
            locationLabel.text = track.startLocation.locationString
            cellBody.addSubview(locationLabel)
            locationLabel.setAnchors(top: timeLabel.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: flatInsets)
            let coordinateLabel = UILabel()
            coordinateLabel.text = track.startLocation.coordinateString
            cellBody.addSubview(coordinateLabel)
            coordinateLabel.setAnchors(top: locationLabel.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, bottom: cellBody.bottomAnchor, insets: flatInsets)
            
        }
    }
    
    @objc func deleteTrack() {
        if track != nil{
            delegate?.deleteTrack(track: track!)
        }
    }
    
    @objc func viewTrack(){
        if track != nil{
            delegate?.viewTrack(track: track!)
        }
    }
    
    @objc func showOnMap(){
        if track != nil{
            delegate?.showOnMap(track: track!)
        }
    }
    
}

