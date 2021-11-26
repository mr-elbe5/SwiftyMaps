/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import CoreLocation

class MapView: UIView {
    
    var scrollView : UIScrollView!
    var tileLayerView = TileLayerView()
    var trackLayerView = TrackLayerView()
    var placeLayerView = PlaceLayerView()
    var userLocationView = UserLocationView()
    var controlLayerView = ControlLayerView()
    
    var scale : CGFloat{
        get{
            scrollView.zoomScale
            // same as contentView.layer.affineTransform().a
        }
    }
    
    var currentMapRegion : MapRegion{
        get{
            MapRegion(topLeft: getCoordinate(screenPoint: CGPoint(x: 0, y: 0)), bottomRight: getCoordinate(screenPoint: CGPoint(x: scrollView.visibleSize.width, y: scrollView.visibleSize.height)), maxZoom: MapStatics.maxZoom)
        }
    }
    
    var contentDrawScale : CGFloat{
        get{
            scale*tileLayerView.layer.contentsScale
        }
    }
    
    var contentOffset : CGPoint{
        get{
            scrollView.contentOffset
        }
    }
    
    var scrollViewPlanetSize : CGSize{
        get{
            CGSize(width: scrollView.contentSize.width/3, height: scrollView.contentSize.height)
        }
    }
    
    func setupScrollView(){
        scrollView = UIScrollView(frame: bounds)
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        scrollView.isDirectionalLockEnabled = false
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.bouncesZoom = false
        scrollView.maximumZoomScale = 1.0
        scrollView.minimumZoomScale = 1.0/MapStatics.zoomScale(at: MapStatics.maxZoom - MapStatics.minZoom)
        addSubview(scrollView)
        scrollView.fillView(view: self)
        scrollView.contentSize = MapStatics.scrollablePlanetSize
        scrollView.delegate = self
    }
    
    func setupTileLayerView(){
        tileLayerView.backgroundColor = .white
        scrollView.addSubview(tileLayerView)
        tileLayerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    func setupTrackLayerView(){
        addSubview(trackLayerView)
        trackLayerView.fillView(view: self)
        //trackLayerView.isHidden = !isTracking
    }
    
    func setupPlaceLayerView(){
        addSubview(placeLayerView)
        placeLayerView.fillView(view: self)
        placeLayerView.setupPlaceMarkers()
        placeLayerView.isHidden = !MapPreferences.instance.showPlaceMarkers
        placeLayerView.isHidden = true
    }
    
    func setupUserLocationView(){
        addSubview(userLocationView)
        userLocationView.isHidden = true
    }
    
    func setupControlLayerView(){
        addSubview(controlLayerView)
        controlLayerView.fillView(view: self)
        controlLayerView.setup()
    }
    
    func getCoordinate(screenPoint: CGPoint) -> CLLocationCoordinate2D{
        let size = scrollViewPlanetSize
        var point = screenPoint
        while point.x >= size.width{
            point.x -= size.width
        }
        point.x += scrollView.contentOffset.x
        point.y += scrollView.contentOffset.y
        return MapStatics.coordinateFromPointInScaledPlanetSize(point: point, scaledSize: size)
    }
    
    func getPlanetRect() -> CGRect{
        getPlanetRect(screenRect: bounds)
    }
    
    func getPlanetRect(screenRect: CGRect) -> CGRect{
        NormalizedPlanetRect(rect: screenRect.offsetBy(dx: contentOffset.x, dy: contentOffset.y), fromScale: scale).rect
    }
    
    func getScreenPoint(coordinate: CLLocationCoordinate2D) -> CGPoint{
        let size = scrollViewPlanetSize
        var xOffset = scrollView.contentOffset.x
        while xOffset > size.width{
            xOffset -= size.width
        }
        var point = MapStatics.pointInScaledSize(coordinate: coordinate, scaledSize: size)
        point.x -= xOffset
        point.y -= scrollView.contentOffset.y
        return point
    }
    
    func scrollToCoordinateAtScreenPoint(coordinate: CLLocationCoordinate2D, point: CGPoint){
        let size = scrollViewPlanetSize
        var x = round((coordinate.longitude + 180)/360.0*size.width) + size.width
        var y = round((1 - log(tan(coordinate.latitude*CGFloat.pi/180.0) + 1/cos(coordinate.latitude*CGFloat.pi/180.0 ))/CGFloat.pi )/2*size.height)
        x = max(0, x - point.x)
        x = min(x, scrollView.contentSize.width - scrollView.visibleSize.width)
        y = max(0, y - point.y)
        y = min(y, scrollView.contentSize.height - scrollView.visibleSize.height)
        scrollView.contentOffset = CGPoint(x: x, y: y)
    }
    
    func scrollToCenteredCoordinate(coordinate: CLLocationCoordinate2D){
        scrollToCoordinateAtScreenPoint(coordinate: coordinate, point: CGPoint(x: scrollView.visibleSize.width/2, y: scrollView.visibleSize.height/2))
    }
    
    func setZoom(zoomLevel: Int, animated: Bool){
        scrollView.setZoomScale(MapStatics.zoomScale(at: zoomLevel - MapStatics.maxZoom), animated: animated)
    }
    
    func setDefaultLocation(){
        setZoom(zoomLevel: MapStatics.minZoom, animated: false)
        scrollToCenteredCoordinate(coordinate: MapStatics.startCoordinate)
    }
    
    func stateDidChange(from: LocationState, to: LocationState, location: CLLocation){
        if from == .none{
            setZoom(zoomLevel: MapStatics.startZoom, animated: true)
            scrollToCenteredCoordinate(coordinate: location.coordinate)
        }
        if to == .exact, userLocationView.isHidden{
            userLocationView.isHidden = false
            userLocationView.updateLocationPoint(planetPoint: MapStatics.planetPointFromCoordinate(coordinate: location.coordinate), offset: contentOffset, scale: scale)
        }
    }
    
    func locationDidChange(location: CLLocation) {
        if !userLocationView.isHidden{
            userLocationView.updateLocationPoint(planetPoint: MapStatics.planetPointFromCoordinate(coordinate: location.coordinate), offset: contentOffset, scale: scale)
        }
        if Tracks.instance.isTracking{
            print("istracking")
            Tracks.instance.updateCurrentTrack(with: location)
            trackLayerView.updateTrack()
            controlLayerView.updateTrackInfo()
        }
    }
    
    func focusUserLocation() {
        if let location = LocationService.shared.lastLocation{
            scrollToCenteredCoordinate(coordinate: location.coordinate)
        }
    }
    
    func setDirection(_ direction: CLLocationDirection) {
        userLocationView.updateDirection(direction: direction)
    }
    
    func addPlaceMarker(place: PlaceData){
        placeLayerView.addPlaceView(place: place)
        Places.instance.save()
        placeLayerView.updatePosition(offset: contentOffset, scale: scale)
    }
    
    func getVisibleCenter() -> CGPoint{
        CGPoint(x: scrollView.visibleSize.width/2, y: scrollView.visibleSize.height/2)
    }
    
    func getVisibleCenterCoordinate() -> CLLocationCoordinate2D{
        getCoordinate(screenPoint: getVisibleCenter())
    }
    
    func mapTypeHasChanged(){
        tileLayerView.setNeedsDisplay()
    }
    
}

extension MapView : UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        tileLayerView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scale = \(scale), minScale = \(MapStatics.minScaleToShowPlaces)")
        placeLayerView.isHidden = (scale < MapStatics.minScaleToShowPlaces)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        assertCenteredContent(scrollView: scrollView)
        userLocationView.updatePosition(offset: contentOffset, scale: scale)
        placeLayerView.updatePosition(offset: contentOffset, scale: scale)
        trackLayerView.updatePosition(offset: contentOffset, scale: scale)
        getPlanetRect()
    }
    
    // for infinite scroll using 3 * content width
    private func assertCenteredContent(scrollView: UIScrollView){
        if scrollView.contentOffset.x >= 2*scrollView.contentSize.width/3{
            scrollView.contentOffset.x -= scrollView.contentSize.width/3
        }
        else if scrollView.contentOffset.x < scrollView.contentSize.width/3{
            scrollView.contentOffset.x += scrollView.contentSize.width/3
        }
    }
    
}





