/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class PopupTableViewController: UIViewController {
    
    var headerView = UIView()
    var tableView = UITableView()
    
    var editButton = IconButton(icon: "pencil.circle", tintColor: .white)
    var closeButton = IconButton(icon: "xmark.circle", tintColor: .white)
    
    override func loadView() {
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
        editButton.setAnchors(top: headerView.topAnchor, trailing: closeButton.leadingAnchor, bottom: headerView.bottomAnchor, insets: wideInsets)
        
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

