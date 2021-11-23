//
//  TrackCell.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.11.21.
//

import UIKit


protocol TrackCellActionDelegate{
    func editTrack(track: TrackData)
    func deleteTrack(track: TrackData)
    func viewTrack(track: TrackData)
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
        cellBody.fillView(view: contentView, insets: Insets.defaultInsets)
        accessoryType = .none
        updateCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isEditing: Bool = false){
        cellBody.removeAllSubviews()
        if track != nil{
            if isEditing{
                let deleteButton = IconButton(icon: "xmark.circle")
                deleteButton.tintColor = UIColor.systemRed
                deleteButton.addTarget(self, action: #selector(deleteTrack), for: .touchDown)
                cellBody.addSubview(deleteButton)
                deleteButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: Insets.defaultInsets)
                
                let editButton = IconButton(icon: "pencil.circle")
                editButton.tintColor = UIColor.systemBlue
                editButton.addTarget(self, action: #selector(editTrack), for: .touchDown)
                cellBody.addSubview(editButton)
                editButton.setAnchors(top: cellBody.topAnchor, trailing: deleteButton.leadingAnchor, insets: Insets.defaultInsets)
            }
            else{
                let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
                viewButton.addTarget(self, action: #selector(viewTrack), for: .touchDown)
                cellBody.addSubview(viewButton)
                viewButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: Insets.defaultInsets)
            }
            let timeLabel = UILabel()
            timeLabel.text = track!.startTime.timeString()
            timeLabel.textAlignment = .center
            cellBody.addSubview(timeLabel)
            timeLabel.setAnchors(top: cellBody.topAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: Insets.defaultInsets)
            let vw = UILabel()
            vw.text = track?.description ?? "no description"
            cellBody.addSubview(vw)
            vw.setAnchors(top: timeLabel.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, bottom: cellBody.bottomAnchor, insets: Insets.defaultInsets)
        }
    }
    
    @objc func editTrack() {
        if track != nil{
            delegate?.editTrack(track: track!)
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
    
}

