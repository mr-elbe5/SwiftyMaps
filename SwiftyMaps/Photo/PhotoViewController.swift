//
//  ImageViewController.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit


class PhotoViewController: PopupViewController, UIScrollViewDelegate {
    
    var uiImage : UIImage? = nil
    var imageView : UIImageView? = nil
    
    override func loadView() {
        self.scrollViewTopPadding = 0
        super.loadView()
        if let image = uiImage{
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            imageView = UIImageView(image: image)
            imageView!.contentMode = .scaleAspectFit
            imageView!.isUserInteractionEnabled = true
            scrollView.addSubview(imageView!)
            imageView!.fillView(view: scrollView)
        }
    }
    
    override func setupHeaderView(){
        setupCloseHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if imageView != nil && imageView!.image != nil{
            let minWidthScale = scrollView.bounds.width / imageView!.image!.size.width
            let minHeightScale = scrollView.bounds.height / imageView!.image!.size.height
            scrollView.minimumZoomScale = min(minWidthScale,minHeightScale)
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
