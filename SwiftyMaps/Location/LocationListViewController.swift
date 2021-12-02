/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

protocol LocationListDelegate: LocationEditDelegate{
    func showOnMap(location: Location)
    func deleteLocation(location: Location)
}

class LocationListViewController: PopupTableViewController{

    private static let CELL_IDENT = "locationCell"
    
    var delegate: LocationListDelegate? = nil
    
    override func loadView() {
        title = "locationList".localize()
        super.loadView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationListViewController.CELL_IDENT)
    }
    
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Locations.instance.size
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationListViewController.CELL_IDENT, for: indexPath) as! LocationCell
        let track = Locations.instance.location(at: indexPath.row)
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

extension LocationListViewController : LocationCellDelegate{
    
    func showOnMap(location: Location) {
        self.dismiss(animated: true){
            self.delegate?.showOnMap(location: location)
        }
    }
    
    func editLocation(location: Location) {
        let locationController = LocationDetailViewController()
        locationController.location = location
        locationController.modalPresentationStyle = .fullScreen
        self.present(locationController, animated: true)
    }
    
    func deleteLocation(location: Location, approved: Bool) {
        if approved{
            deleteLocation(location: location)
        }
        else{
            showApprove(title: "confirmDeleteLocation".localize(), text: "deleteLocationInfo".localize()){
                self.deleteLocation(location: location)
            }
        }
    }
    
    private func deleteLocation(location: Location){
        delegate?.deleteLocation(location: location)
        self.tableView.reloadData()
    }
    
    func viewLocation(location: Location) {
        let locationController = LocationDetailViewController()
        locationController.delegate = self
        locationController.location = location
        locationController.modalPresentationStyle = .fullScreen
        self.present(locationController, animated: true)
    }
    
}

extension LocationListViewController: LocationEditDelegate{
    
    func updateLocationLayer() {
        delegate?.updateLocationLayer()
    }
    
    func updateLocationState(location: Location) {
        delegate?.updateLocationState(location: location)
    }
    
}

