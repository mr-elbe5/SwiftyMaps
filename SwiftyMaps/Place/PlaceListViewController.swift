//
//  PlaceListViewController.swift
//  SwiftyMaps
//
//  Created by Michael Rönnau on 22.11.21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import CoreLocation

protocol PlaceListDelegate{
    func updatePlaceLayer()
    func showOnMap(place: PlaceData)
}

class PlaceListViewController: UIViewController{

    private static let CELL_IDENT = "placeCell"
    
    var firstAppearance = true
    
    var headerView = UIView()
    var editButton = IconButton(icon: "pencil.circle", tintColor: .white)
    var tableView = UITableView()
    
    var delegate: PlaceListDelegate? = nil
    
    override open func loadView() {
        title = "placeList".localize()
        super.loadView()
        view.backgroundColor = .systemGray5
        let guide = view.safeAreaLayoutGuide
        let spacer = UIView()
        spacer.backgroundColor = .systemGray6
        view.addSubview(spacer)
        spacer.setAnchors(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: guide.topAnchor, insets: .zero)
        view.addSubview(headerView)
        setupHeaderView()
        headerView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: Insets.defaultInsets)
        view.addSubview(tableView)
        tableView.setAnchors(top: headerView.bottomAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceListViewController.CELL_IDENT)
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
        
    }
    
    func setNeedsUpdate(){
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstAppearance{
            if PlaceController.instance.places.count > 0{
                tableView.scrollToRow(at: .init(row: PlaceController.instance.places.count - 1, section: 0), at: .bottom, animated: true)
            }
            firstAppearance = false
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

extension PlaceListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PlaceController.instance.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceListViewController.CELL_IDENT, for: indexPath) as! PlaceCell
        let track = PlaceController.instance.places[indexPath.row]
        cell.place = track
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

extension PlaceListViewController : PlaceCellActionDelegate{
    
    func showOnMap(place: PlaceData) {
        self.dismiss(animated: true){
            self.delegate?.showOnMap(place: place)
        }
    }
    
    
    func editPlace(place: PlaceData) {
        let placeController = PlaceEditViewController()
        placeController.place = place
        placeController.modalPresentationStyle = .fullScreen
        self.present(placeController, animated: true)
    }
    
    func deletePlace(place: PlaceData) {
        showApprove(title: "confirmDeletePlace".localize(), text: "deletePlaceInfo".localize()){
            PlaceController.instance.deletePlace(place)
            self.tableView.reloadData()
        }
    }
    
    func viewPlace(place: PlaceData) {
        let placeController = PlaceViewController()
        placeController.place = place
        placeController.modalPresentationStyle = .fullScreen
        self.present(placeController, animated: true)
    }
    
}

