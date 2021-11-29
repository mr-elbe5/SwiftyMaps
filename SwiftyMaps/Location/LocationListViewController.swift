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
}

class LocationListViewController: UIViewController{

    private static let CELL_IDENT = "locationCell"
    
    var headerView = UIView()
    var editButton = IconButton(icon: "pencil.circle", tintColor: .white)
    var tableView = UITableView()
    
    var delegate: LocationListDelegate? = nil
    
    override open func loadView() {
        title = "locationList".localize()
        super.loadView()
        view.backgroundColor = .systemGray5
        let guide = view.safeAreaLayoutGuide
        let spacer = UIView()
        spacer.backgroundColor = .systemGray6
        view.addSubview(spacer)
        spacer.setAnchors(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: guide.topAnchor, insets: .zero)
        view.addSubview(headerView)
        setupHeaderView()
        headerView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: defaultInsets)
        view.addSubview(tableView)
        tableView.setAnchors(top: headerView.bottomAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationListViewController.CELL_IDENT)
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
            label.setAnchors(top: headerView.topAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
                .centerX(headerView.centerXAnchor)
        }
        
        let closeButton = IconButton(icon: "xmark.circle", tintColor: .white)
        headerView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        closeButton.setAnchors(top: headerView.topAnchor, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        
        
        headerView.addSubview(editButton)
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchDown)
        editButton.setAnchors(top: headerView.topAnchor, trailing: closeButton.leadingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        
    }
    
    func setNeedsUpdate(){
        tableView.reloadData()
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

extension LocationListViewController : LocationCellActionDelegate{
    
    func showOnMap(location: Location) {
        self.dismiss(animated: true){
            self.delegate?.showOnMap(location: location)
        }
    }
    
    
    func editLocation(location: Location) {
        let locationController = LocationViewController()
        locationController.location = location
        locationController.modalPresentationStyle = .fullScreen
        self.present(locationController, animated: true)
    }
    
    func deleteLocation(location: Location) {
        showApprove(title: "confirmDeleteLocation".localize(), text: "deleteLocationInfo".localize()){
            Locations.instance.deleteLocation(location)
            self.tableView.reloadData()
        }
    }
    
    func viewLocation(location: Location) {
        let locationController = LocationViewController()
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

