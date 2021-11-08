//
//  ScrollViewController.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class PopupViewController: UIViewController {
    
    var headerView = UIView()
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        let guide = view.safeAreaLayoutGuide
        setupHeaderView()
        view.addSubview(headerView)
        headerView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: nil, insets: .zero)
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = .systemBackground
        scrollView.setAnchors(top: headerView.bottomAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0))
        scrollView.addSubview(contentView)
        contentView.setAnchors(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: scrollView.bottomAnchor, insets: .zero)
        //needed? 
        /*let scflg = scrollView.contentLayoutGuide
        let svflg = scrollView.frameLayoutGuide
        scflg.widthAnchor.constraint(equalTo: svflg.widthAnchor).isActive = true*/
    }
    
    func setupHeaderView(){
        headerView.backgroundColor = .black
        if let title = title{
            let label = UILabel()
            label.text = title
            label.textColor = .white
            headerView.addSubview(label)
            label.setAnchors(top: headerView.topAnchor, leading: nil, trailing: nil, bottom: headerView.bottomAnchor, insets: Insets.defaultInsets)
                .centerX(headerView.centerXAnchor)
        }
        let closeButton = IconButton(icon: "xmark.circle", tintColor: .white)
        headerView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        closeButton.setAnchors(top: headerView.topAnchor, leading: nil, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, insets: Insets.defaultInsets)
    }
    
    func setupKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){

        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardDidShow(notification:NSNotification){
        if let firstResponder = contentView.firstResponder{
            let rect : CGRect = firstResponder.frame
            var parentView = firstResponder.superview
            var offset : CGFloat = 0
            while parentView != nil && parentView != scrollView {
                offset += parentView!.frame.minY
                parentView = parentView?.superview
            }
            scrollView.scrollRectToVisible(.init(x: rect.minX, y: rect.minY + offset, width: rect.width, height: rect.height), animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: {
        })
    }
    
}
