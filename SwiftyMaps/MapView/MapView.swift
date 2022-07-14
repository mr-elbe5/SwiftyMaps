/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import CoreLocation

class MapView: UIView {
    
    var scrollView : UIScrollView!
    var tileLayerView = TileLayerView()
    var trackLayerView = TrackLayerView()
    var locationLayerView = LocationLayerView()
    var userLocationView = UserLocationView()
    var controlLayerView = ControlLayerView()
    
    var scale: CGFloat{
        scrollView.zoomScale
        // same as contentView.layer.affineTransform().a
    }
    
    var zoom: Int = 0
    var position : MapPosition? = MapPosition.loadPosition()
    var startLocationIsSet = false
    
    var currentMapRegion : MapRegion{
        MapRegion(topLeft: getCoordinate(screenPoint: CGPoint(x: 0, y: 0)), bottomRight: getCoordinate(screenPoint: CGPoint(x: scrollView.visibleSize.width, y: scrollView.visibleSize.height)), maxZoom: MapStatics.maxZoom)
    }
    
    var contentDrawScale : CGFloat{
        scale*tileLayerView.layer.contentsScale
    }
    
    var contentOffset : CGPoint{
        scrollView.contentOffset
    }
    
    var scrollViewPlanetSize : CGSize{
        CGSize(width: scrollView.contentSize.width/3, height: scrollView.contentSize.height)
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
        trackLayerView.backgroundColor = .clear
        addSubview(trackLayerView)
        trackLayerView.fillView(view: self)
    }
    
    func setupLocationLayerView(){
        addSubview(locationLayerView)
        locationLayerView.fillView(view: self)
        locationLayerView.isHidden = !Preferences.instance.showPins
    }
    
    func setupUserLocationView(){
        userLocationView.backgroundColor = .clear
        addSubview(userLocationView)
        userLocationView.fillView(view: self)
    }
    
    func setupControlLayerView(){
        addSubview(controlLayerView)
        controlLayerView.fillView(view: self)
        controlLayerView.setup()
    }

    func clearTiles(){
        tileLayerView.tileLayer.setNeedsDisplay()
    }
    
    func clearTrack(_ track: TrackData? = nil){
        if track == nil || trackLayerView.track == track{
            trackLayerView.setTrack(track: nil)
        }
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
    
    func updateLocationLayer(){
        locationLayerView.setupPins(zoom: zoom, offset: contentOffset, scale: scale)
    }
    
    func updatePinVisibility(){
        locationLayerView.isHidden = !Preferences.instance.showPins
    }
    
    func updateTrackLayer(){
        trackLayerView.setNeedsDisplay()
    }
    
    func scaleTo(scale: Double, animated : Bool = false){
        scrollView.setZoomScale(scale, animated: animated)
        updateZoom()
    }
    
    func zoomTo(zoom: Int, animated: Bool){
        scaleTo(scale: MapStatics.zoomScale(at: zoom - MapStatics.maxZoom), animated: animated)
        self.zoom = zoom
        updateLocationLayer()
    }
    
    func setDefaultLocation(){
        if Preferences.instance.startWithLastPosition, let pos = position{
            scaleTo(scale: pos.scale)
            scrollToCenteredCoordinate(coordinate: pos.coordinate)
            startLocationIsSet = true
            updateLocationLayer()
        }
        else{
            zoomTo(zoom: MapStatics.minZoom, animated: false)
            scrollToCenteredCoordinate(coordinate: MapStatics.startCoordinate)
            updateLocationLayer()
        }
    }
    
    func focusUserLocation() {
        if let position = LocationService.shared.lastPosition{
            scrollToCenteredCoordinate(coordinate: position.coordinate)
        }
    }
    
    func getVisibleCenter() -> CGPoint{
        CGPoint(x: scrollView.visibleSize.width/2, y: scrollView.visibleSize.height/2)
    }
    
    func getVisibleCenterCoordinate() -> CLLocationCoordinate2D{
        getCoordinate(screenPoint: getVisibleCenter())
    }
    
    func updatePosition(){
        position = MapPosition(scale: scrollView.zoomScale, coordinate: getVisibleCenterCoordinate())
    }
    
    func updateZoom(){
        let zoom = MapStatics.zoomLevelFromReverseScale(scale: scale)
        if zoom != self.zoom{
            self.zoom = zoom
            locationLayerView.setupPins(zoom: zoom, offset: contentOffset, scale: scale)
        }
    }
    
    func savePosition(){
        if let pos = position{
            pos.save()
        }
    }
    
}

extension MapView: LocationServiceDelegate{
    
    func authorizationDidChange(authorization: CLAuthorizationStatus, position: Position) {
        if authorization.rawValue >= CLAuthorizationStatus.authorizedWhenInUse.rawValue{
            if !startLocationIsSet{
                zoomTo(zoom: MapStatics.minZoom, animated: false)
                scrollToCenteredCoordinate(coordinate: position.coordinate)
                updatePosition()
                updateLocationLayer()
                startLocationIsSet = true
            }
        }
    }
    
    func positionDidChange(position: Position) {
        if !startLocationIsSet{
            zoomTo(zoom: MapStatics.minZoom, animated: false)
            scrollToCenteredCoordinate(coordinate: position.coordinate)
            updatePosition()
            updateLocationLayer()
            startLocationIsSet = true
        }
        else{
            userLocationView.updateLocationPoint(planetPoint: MapStatics.planetPointFromCoordinate(coordinate: position.coordinate), accuracy: position.horizontalAccuracy, offset: contentOffset, scale: scale)
            controlLayerView.updateLocationInfo(position: position)
            if TrackPool.isTracking{
                TrackPool.updateTrack(with: position)
                trackLayerView.updateTrack()
                controlLayerView.updateTrackInfo()
            }
        }
    }
    
    func headingDidChange(heading: Int) {
        userLocationView.updateDirection(heading: heading)
        controlLayerView.updateHeadingInfo(heading: heading)
    }
    
}

extension MapView : UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        tileLayerView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        updatePosition()
        updateZoom()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        assertCenteredContent(scrollView: scrollView)
        updatePosition()
        if startLocationIsSet{
            userLocationView.updatePosition(offset: contentOffset, scale: scale)
        }
        locationLayerView.updatePosition(offset: contentOffset, scale: scale)
        trackLayerView.updatePosition(offset: contentOffset, scale: scale)
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





