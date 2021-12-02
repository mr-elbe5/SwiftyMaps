/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

protocol TrackListDelegate{
    func showTrackOnMap(track: TrackData)
    func deleteTrack(track: TrackData, approved: Bool)
    func pauseCurrentTrack()
    func resumeCurrentTrack()
    func cancelCurrentTrack()
    func saveCurrentTrack()
}

class TrackListViewController: PopupTableViewController{

    private static let CELL_IDENT = "trackCell"
    
    // MainViewController
    var delegate: TrackListDelegate? = nil
    
    override open func loadView() {
        title = "trackList".localize()
        super.loadView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackListViewController.CELL_IDENT)
    }
    
    override func setupHeaderView(){
        super.setupHeaderView()
        
        let loadButton = IconButton(icon: "arrow.down.square", tintColor: .white)
        headerView.addSubview(loadButton)
        loadButton.addTarget(self, action: #selector(loadTrack), for: .touchDown)
        loadButton.setAnchors(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
    }
    
    @objc func loadTrack(){
        let filePicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "gpx")!])
        filePicker.directoryURL = FileController.gpxDirURL
        filePicker.allowsMultipleSelection = false
        filePicker.delegate = self
        filePicker.modalPresentationStyle = .fullScreen
        self.present(filePicker, animated: true)
    }
    
}

extension TrackListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Tracks.instance.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackListViewController.CELL_IDENT, for: indexPath) as! TrackCell
        let track = Tracks.instance.tracks[indexPath.row]
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

extension TrackListViewController : TrackCellDelegate, TrackDetailDelegate{
    
    func showTrackOnMap(track: TrackData) {
        self.dismiss(animated: true){
            self.delegate?.showTrackOnMap(track: track)
        }
    }
    
    func viewTrackDetails(track: TrackData) {
        let trackController = TrackDetailViewController()
        trackController.track = track
        trackController.delegate = self
        trackController.modalPresentationStyle = .fullScreen
        self.present(trackController, animated: true)
    }
    
    func deleteTrack(track: TrackData, approved: Bool) {
        if approved{
            self.deleteTrack(track: track)
        }
        else{
            showApprove(title: "confirmDeleteTrack".localize(), text: "deleteTrackInfo".localize()){
                self.deleteTrack(track: track)
            }
        }
    }
    
    private func deleteTrack(track: TrackData){
        delegate?.deleteTrack(track: track, approved: true)
        tableView.reloadData()
    }
    
    func pauseCurrentTrack() {
        delegate?.pauseCurrentTrack()
    }
    
    func resumeCurrentTrack() {
        delegate?.resumeCurrentTrack()
    }
    
    func cancelCurrentTrack() {
        delegate?.cancelCurrentTrack()
    }
    
    func saveCurrentTrack() {
        delegate?.saveCurrentTrack()
    }
    
}

extension TrackListViewController : UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first{
            if let locations = GPXParser.parseFile(url: url){
                guard !locations.isEmpty else {return}
                let track = TrackData(locations: locations)
                let alertController = UIAlertController(title: "name".localize(), message: "nameOrDescriptionHint".localize(), preferredStyle: .alert)
                alertController.addTextField()
                alertController.addAction(UIAlertAction(title: "ok".localize(),style: .default) { action in
                    track.description = alertController.textFields![0].text ?? url.lastPathComponent
                    Tracks.instance.addTrack(track)
                    Tracks.instance.save()
                    self.tableView.reloadData()
                })
                self.present(alertController, animated: true)
            }
        }
    }
    
}
