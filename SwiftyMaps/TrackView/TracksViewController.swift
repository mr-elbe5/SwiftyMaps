/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

//MapViewController
protocol TracksViewDelegate{
    func showTrackOnMap(track: TrackData)
    func deleteTrack(track: TrackData, approved: Bool)
}

class TracksViewController: HeaderTableViewController{

    private static let CELL_IDENT = "trackCell"
    
    var tracks: TrackList? = nil
    
    //MapViewController
    var delegate: TracksViewDelegate? = nil
    
    override open func loadView() {
        tracks = TrackPool.tracks
        super.loadView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackCell.self, forCellReuseIdentifier: TracksViewController.CELL_IDENT)
    }
    
    override func setupHeaderView(){
        super.setupHeaderView()
        let loadButton = IconButton(icon: "arrow.down.square", tintColor: .systemBlue)
        headerView.addSubview(loadButton)
        loadButton.addTarget(self, action: #selector(importTrack), for: .touchDown)
        loadButton.setAnchors(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        let deleteButton = IconButton(icon: "trash", tintColor: .systemRed)
        headerView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteAllTracks), for: .touchDown)
        deleteButton.setAnchors(top: headerView.topAnchor, leading: loadButton.trailingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
    }
    
    @objc func importTrack(){
        let filePicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "gpx")!])
        filePicker.directoryURL = FileController.gpxDirURL
        filePicker.allowsMultipleSelection = false
        filePicker.delegate = self
        filePicker.modalPresentationStyle = .fullScreen
        self.present(filePicker, animated: true)
    }
    
    @objc func deleteAllTracks(){
        showDestructiveApprove(title: "confirmDeleteTracks".localize(), text: "deleteTracksHint".localize()){
            TrackPool.cancelTracking()
            TrackPool.deleteAllTracks()
            self.mapViewController.mapView.clearTrack()
        }
    }
    
}

extension TracksViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TracksViewController.CELL_IDENT, for: indexPath) as! TrackCell
        let track = tracks?[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension TracksViewController : TrackDetailDelegate{
    
    func showTrackOnMap(track: TrackData) {
        self.dismiss(animated: true){
            self.delegate?.showTrackOnMap(track: track)
        }
    }
    
}

extension TracksViewController : TrackCellDelegate{
    
    func viewTrackDetails(track: TrackData) {
        let trackController = TrackDetailViewController()
        trackController.track = track
        trackController.delegate = self
        trackController.modalPresentationStyle = .fullScreen
        self.present(trackController, animated: true)
    }
    
    func exportTrack(track: TrackData) {
        if let url = GPXCreator.createTemporaryFile(track: track){
            let controller = UIDocumentPickerViewController(forExporting: [url], asCopy: false)
            present(controller, animated: true) {
                FileController.logFileInfo()
            }
        }
    }
    
    func deleteTrack(track: TrackData) {
        showDestructiveApprove(title: "confirmDeleteTrack".localize(), text: "deleteTrackHint".localize()){
            self.delegate?.deleteTrack(track: track, approved: true)
            self.tracks?.remove(obj: track)
            self.tableView.reloadData()
        }
    }
    
}

extension TracksViewController : UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first{
            if let positions = GPXParser.parseFile(url: url), !positions.isEmpty{
                let track = TrackData()
                for pos in positions{
                    track.trackpoints.append(pos)
                }
                track.evaluateTrackpoints()
                let alertController = UIAlertController(title: "name".localize(), message: "nameOrDescriptionHint".localize(), preferredStyle: .alert)
                alertController.addTextField()
                alertController.addAction(UIAlertAction(title: "ok".localize(),style: .default) { action in
                    track.name = alertController.textFields![0].text ?? url.lastPathComponent
                    TrackPool.addTrack(track: track)
                    LocationPool.save()
                    self.tracks?.append(track)
                    self.tableView.reloadData()
                })
                self.present(alertController, animated: true)
            }
        }
    }
    
}
