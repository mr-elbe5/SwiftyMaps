//
//  TrackListViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.11.21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

protocol TrackListDelegate{
    func trackLoaded()
}

class TrackListViewController: UIViewController{

    private static let CELL_IDENT = "trackCell"
    
    var firstAppearance = true
    
    var headerView = UIView()
    var editButton = IconButton(icon: "pencil.circle", tintColor: .white)
    var tableView = UITableView()
    
    var delegate: TrackListDelegate? = nil
    
    override open func loadView() {
        title = "trackList".localize()
        super.loadView()
        view.backgroundColor = .systemGray5
        let guide = view.safeAreaLayoutGuide
        let spacer = UIView()
        spacer.backgroundColor = .systemGray6
        view.addSubview(spacer)
        spacer.setAnchors(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: guide.topAnchor, insets: .zero)
        view.addSubview(headerView)
        setupHeaderView()
        headerView.setAnchors()
            .leading(guide.leadingAnchor)
            .top(guide.topAnchor)
            .trailing(guide.trailingAnchor)
        view.addSubview(tableView)
        tableView.setAnchors(top: headerView.bottomAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackListViewController.CELL_IDENT)
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray6
    }
    
    func setupHeaderView(){
        headerView.backgroundColor = .black
        if let title = title{
            let label = UILabel()
            label.text = title
            label.textColor = .white
            headerView.addSubview(label)
            label.setAnchors(top: headerView.topAnchor, bottom: headerView.bottomAnchor, insets: Insets.defaultInsets)
                .centerX(headerView.centerXAnchor)
        }
        
        let closeButton = IconButton(icon: "xmark.circle", tintColor: .white)
        headerView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        closeButton.setAnchors(top: headerView.topAnchor, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, insets: Insets.defaultInsets)
        
        
        headerView.addSubview(editButton)
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchDown)
        editButton.setAnchors(top: headerView.topAnchor, trailing: closeButton.leadingAnchor, bottom: headerView.bottomAnchor, insets: Insets.defaultInsets)
        
        let loadButton = IconButton(icon: "arrow.down.square", tintColor: .white)
        headerView.addSubview(loadButton)
        loadButton.addTarget(self, action: #selector(loadTrack), for: .touchDown)
        loadButton.setAnchors(top: headerView.topAnchor, trailing: editButton.leadingAnchor, bottom: headerView.bottomAnchor, insets: Insets.defaultInsets)
    }
    
    func setNeedsUpdate(){
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstAppearance{
            if TrackController.instance.tracks.count > 0{
                tableView.scrollToRow(at: .init(row: TrackController.instance.tracks.count - 1, section: 0), at: .bottom, animated: true)
            }
            firstAppearance = false
        }
    }
    
    @objc func loadTrack(){
        let filePicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "gpx")!])
        filePicker.directoryURL = FileController.gpxDirURL
        filePicker.allowsMultipleSelection = false
        filePicker.delegate = self
        filePicker.modalPresentationStyle = .fullScreen
        self.present(filePicker, animated: true){
            self.delegate?.trackLoaded()
        }
    }
    
    @objc func toggleEditMode(){
        if !tableView.isEditing{
            editButton.tintColor = .systemRed
            tableView.setEditing(true, animated: true)
        }
        else{
            editButton.tintColor = .white
            tableView.setEditing(false, animated: true)
        }
        tableView.reloadData()
    }
    
    @objc func close(){
        self.dismiss(animated: true)
    }
    
}

extension TrackListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TrackController.instance.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackListViewController.CELL_IDENT, for: indexPath) as! TrackCell
        let track = TrackController.instance.tracks[indexPath.row]
        cell.track = track
        cell.delegate = self
        cell.updateCell(isEditing: tableView.isEditing)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
}

extension TrackListViewController : TrackCellActionDelegate{
    
    func deleteTrack(track: TrackData) {
        showApprove(title: "reallyDeleteEntry".localize(), text: "deleteEntryApproveInfo".localize()){
            TrackController.instance.deleteTrack(track)
            self.tableView.reloadData()
        }
    }
    
    func viewTrack(track: TrackData) {
        let trackController = TrackViewController()
        trackController.track = track
        trackController.modalPresentationStyle = .fullScreen
        self.present(trackController, animated: true)
    }
    
}

extension TrackListViewController : UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first{
            if let locations = GPXParser.parseFile(url: url){
                let track = TrackData()
                track.description = url.lastPathComponent
                for location in locations{
                    track.trackpoints.append(TrackPoint(location: location))
                }
                //track.dump()
                TrackController.currentTrack = track
                TrackController.instance.addTrack(track)
                TrackController.instance.save()
                self.dismiss(animated: true){
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
