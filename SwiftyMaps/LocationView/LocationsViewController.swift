/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

protocol LocationsDelegate: LocationViewDelegate{
    func showOnMap(location: LocationData)
    func deleteLocation(location: LocationData)
}

class LocationsViewController: HeaderTableViewController{

    private static let CELL_IDENT = "locationCell"
    
    var delegate: LocationsDelegate? = nil
    
    override func loadView() {
        title = "locationList".localize()
        super.loadView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationsViewController.CELL_IDENT)
    }
    
    override func setupHeaderView(){
        super.setupHeaderView()
        let deleteButton = IconButton(icon: "trash", tintColor: .systemRed)
        headerView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteLocations), for: .touchDown)
        deleteButton.setAnchors(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
    }
    
    @objc func deleteLocations() {
        showDestructiveApprove(title: "confirmDeleteLocations".localize(), text: "deleteLocationsHint".localize()){
            LocationPool.deleteAllLocations()
            self.updateLocationLayer()
            mapViewController.mapView.clearTrack()
        }
    }
    
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LocationPool.size
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationsViewController.CELL_IDENT, for: indexPath) as! LocationCell
        let track = LocationPool.location(at: indexPath.row)
        cell.location = track
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

extension LocationsViewController : LocationCellDelegate{
    
    func showOnMap(location: LocationData) {
        self.dismiss(animated: true){
            self.delegate?.showOnMap(location: location)
        }
    }
    
    func deleteLocation(location: LocationData, approved: Bool) {
        if approved{
            deleteLocation(location: location)
        }
        else{
            showDestructiveApprove(title: "confirmDeleteLocation".localize(), text: "deleteLocationInfo".localize()){
                self.deleteLocation(location: location)
            }
        }
    }
    
    private func deleteLocation(location: LocationData){
        delegate?.deleteLocation(location: location)
        self.tableView.reloadData()
    }
    
    func viewLocationDetails(location: LocationData) {
        let locationController = LocationDetailViewController()
        locationController.delegate = self
        locationController.location = location
        locationController.modalPresentationStyle = .fullScreen
        self.present(locationController, animated: true)
    }
    
}

extension LocationsViewController: LocationViewDelegate{
    
    func updateLocationLayer() {
        delegate?.updateLocationLayer()
    }
    
}

