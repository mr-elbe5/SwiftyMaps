/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

//TracksViewController
protocol TrackCellDelegate{
    func showTrackOnMap(track: TrackData)
    func viewTrackDetails(track: TrackData)
    func exportTrack(track: TrackData)
    func deleteTrack(track: TrackData)
}

// used by TracksViewController
class TrackCell: UITableViewCell{
    
    var track : TrackData? = nil {
        didSet {
            updateCell()
        }
    }
    
    //TracksViewController
    var delegate: TrackCellDelegate? = nil
    
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
        if let trackData = track{
            let trackContainerView = UIView()
            cellBody.addSubview(trackContainerView)
            trackContainerView.fillView(view: cellBody)
            let deleteButton = IconButton(icon: "trash")
            deleteButton.tintColor = UIColor.systemRed
            deleteButton.addTarget(self, action: #selector(deleteTrack), for: .touchDown)
            trackContainerView.addSubview(deleteButton)
            deleteButton.setAnchors(top: trackContainerView.topAnchor, trailing: trackContainerView.trailingAnchor, insets: defaultInsets)
            let exportButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue)
            exportButton.addTarget(self, action: #selector(exportTrack), for: .touchDown)
            trackContainerView.addSubview(exportButton)
            exportButton.setAnchors(top: trackContainerView.topAnchor, trailing: deleteButton.leadingAnchor, insets: defaultInsets)
            let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
            viewButton.addTarget(self, action: #selector(viewTrack), for: .touchDown)
            trackContainerView.addSubview(viewButton)
            viewButton.setAnchors(top: trackContainerView.topAnchor, trailing: exportButton.leadingAnchor, insets: defaultInsets)
            let showOnMapButton = IconButton(icon: "map", tintColor: .systemBlue)
            showOnMapButton.addTarget(self, action: #selector(showTrackOnMap), for: .touchDown)
            trackContainerView.addSubview(showOnMapButton)
            showOnMapButton.setAnchors(top: trackContainerView.topAnchor, trailing: viewButton.leadingAnchor, insets: defaultInsets)
            let trackView = UIView()
            trackView.setGrayRoundedBorders()
            trackContainerView.addSubview(trackView)
            trackView.setAnchors(top: showOnMapButton.bottomAnchor, leading: trackContainerView.leadingAnchor, trailing: trackContainerView.trailingAnchor, bottom: trackContainerView.bottomAnchor, insets: UIEdgeInsets(top: 2, left: defaultInset, bottom: defaultInset, right: defaultInset))
            let header = UILabel(header: trackData.name)
            trackView.addSubview(header)
            header.setAnchors(top: trackView.topAnchor, leading: trackView.leadingAnchor, insets: defaultInsets)
            let coordinateLabel = UILabel(text: trackData.trackpoints.first?.coordinate.coordinateString ?? "")
            trackView.addSubview(coordinateLabel)
            coordinateLabel.setAnchors(top: header.bottomAnchor, leading: trackView.leadingAnchor, trailing: trackView.trailingAnchor, insets: flatInsets)
            let timeLabel = UILabel(text: "\(trackData.startTime.dateTimeString()) - \(trackData.endTime.dateTimeString())")
            trackView.addSubview(timeLabel)
            timeLabel.setAnchors(top: coordinateLabel.bottomAnchor, leading: trackView.leadingAnchor, trailing: trackView.trailingAnchor, insets: flatInsets)
            let distanceLabel = UILabel(text: "\("distance".localize()): \(Int(trackData.distance))m")
            trackView.addSubview(distanceLabel)
            distanceLabel.setAnchors(top: timeLabel.bottomAnchor, leading: trackView.leadingAnchor, insets: flatInsets)
            let upDistanceLabel = UILabel(text: "\("upDistance".localize()): \(Int(trackData.upDistance))m")
            trackView.addSubview(upDistanceLabel)
            upDistanceLabel.setAnchors(top: distanceLabel.bottomAnchor, leading: trackView.leadingAnchor, insets: flatInsets)
            let downDistanceLabel = UILabel(text: "\("downDistance".localize()): \(Int(trackData.downDistance))m")
            trackView.addSubview(downDistanceLabel)
            downDistanceLabel.setAnchors(top: upDistanceLabel.bottomAnchor, leading: trackView.leadingAnchor, insets: flatInsets)
            let durationLabel = UILabel(text: "\("duration".localize()): \(trackData.duration.hmsString())")
            trackView.addSubview(durationLabel)
            durationLabel.setAnchors(top: downDistanceLabel.bottomAnchor, leading: trackView.leadingAnchor, bottom: trackView.bottomAnchor, insets: UIEdgeInsets(top: 0, left: defaultInset, bottom: defaultInset, right: defaultInset))
        }
    }
    
    func setupTrackView(){
        
    }
    
    @objc func viewTrack(){
        if let track = track{
            delegate?.viewTrackDetails(track: track)
        }
    }
    
    @objc func showTrackOnMap(){
        if let track = track{
            delegate?.showTrackOnMap(track: track)
        }
    }
    
    @objc func exportTrack(){
        if let track = track{
            delegate?.exportTrack(track: track)
        }
    }
    
    @objc func deleteTrack(){
        if let track = track{
            delegate?.deleteTrack(track: track)
        }
    }
    
}

