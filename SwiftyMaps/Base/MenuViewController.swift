//
//  MenuViewController.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import SwiftyIOSViewExtensions

open class MenuViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var closeView = UIButton()
    var closeView2 = UIButton()
    
    override open func loadView() {
        super.loadView()
        view.backgroundColor = .clear
        let guide = view.safeAreaLayoutGuide
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = .yellow
        scrollView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(guide.topAnchor, inset: .zero)
            .trailing(guide.trailingAnchor,inset: .zero)
            .bottom(guide.bottomAnchor, inset: .zero)
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.backgroundColor = .white
        stackView.setAnchors()
            .top(scrollView.topAnchor)
            .leading(scrollView.leadingAnchor)
            .trailing(scrollView.centerXAnchor)
            .bottom(scrollView.bottomAnchor)
        stackView.setupVertical()
        addMenuItems()
        closeView.backgroundColor = .green
        closeView.addTarget(self, action: #selector(close), for: .touchDown)
        scrollView.addSubview(closeView)
        closeView.setAnchors()
            .top(scrollView.topAnchor)
            .leading(scrollView.centerXAnchor)
            .trailing(scrollView.trailingAnchor)
            .bottom(scrollView.bottomAnchor)
        closeView2.backgroundColor = .blue
        closeView2.addTarget(self, action: #selector(close), for: .touchDown)
        scrollView.addSubview(closeView2)
        closeView2.setAnchors()
            .top(stackView.bottomAnchor)
            .leading(scrollView.leadingAnchor)
            .trailing(scrollView.trailingAnchor)
            .bottom(scrollView.bottomAnchor)
    }
    
    func addMenuItems(){
        let closeButton = IconButton(icon: "xmark.circle")
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        stackView.addArrangedSubview(closeButton)
    }
    
    @objc func close(){
        self.dismiss(animated: false, completion: {
        })
    }
    
}
