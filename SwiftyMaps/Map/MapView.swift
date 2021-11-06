/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit
import CoreLocation

class MapView: UIView {
    
    var controller : UIViewController

    var scrollView : UIScrollView!
    var contentView = MapContentView()
    var annotationView = MapAnnotationView()
    var userLocationView = UserLocationView()
    var controlView = MapControlView()
    
    var locationInitialized = false
    
    var scale : CGFloat{
        get{
            scrollView.zoomScale
            // same as contentView.layer.affineTransform().a
        }
    }
    
    var contentDrawScale : CGFloat{
        get{
            scale*contentView.layer.contentsScale
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
    
    init(controller: UIViewController) {
        self.controller = controller
        super.init(frame: controller.view.bounds)
        let minZoom = MapCalculator.minimumZoomLevelForViewSize(viewSize: bounds.size)
        setupScrollView(minimalZoom: minZoom)
        setupContentView()
        setupUserLocationView()
        setupAnnotationView()
        setupControlView()
    }
    
    private func setupScrollView(minimalZoom: Int){
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
        scrollView.minimumZoomScale = 1.0/MapCalculator.zoomScale(at: MapStatics.maxZoom - minimalZoom)
        addSubview(scrollView)
        scrollView.fillView(view: self)
        scrollView.contentSize = MapStatics.scrollablePlanetSize
        scrollView.delegate = self
    }
    
    private func setupContentView(){
        contentView.backgroundColor = .white
        scrollView.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    private func setupAnnotationView(){
        addSubview(annotationView)
        annotationView.fillView(view: self)
        annotationView.setupAnnotations()
        annotationView.delegate = self
        annotationView.isHidden = !Preferences.instance.showAnnotations
    }
    
    private func setupUserLocationView(){
        addSubview(userLocationView)
    }
    
    private func setupControlView(){
        addSubview(controlView)
        controlView.fillView(view: self)
        controlView.setup()
        controlView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCoordinate(screenPoint: CGPoint) -> CLLocationCoordinate2D{
        let size = scrollViewPlanetSize
        var point = screenPoint
        while point.x >= size.width{
            point.x -= size.width
        }
        point.x += scrollView.contentOffset.x
        point.y += scrollView.contentOffset.y
        return MapCalculator.coordinateFromPointInScaledPlanetSize(point: point, scaledSize: size)
    }
    
    func getScreenPoint(coordinate: CLLocationCoordinate2D) -> CGPoint{
        let size = scrollViewPlanetSize
        var xOffset = scrollView.contentOffset.x
        while xOffset > size.width{
            xOffset -= size.width
        }
        var point = MapCalculator.pointInScaledSize(coordinate: coordinate, scaledSize: size)
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
        scrollView.setZoomScale(MapCalculator.zoomScale(at: zoomLevel - MapStatics.maxZoom), animated: animated)
    }
    
    func connectLocationService(){
        LocationService.shared.delegate = self
        if LocationService.shared.authorized{
            initLocation()
        }
    }
    
    func disconnectLocationService() {
        LocationService.shared.delegate = nil
    }
    
    func initLocation(){
        if !locationInitialized, let loc = LocationService.shared.location{
            locationInitialized = true
            print("location initialized")
            setZoom(zoomLevel: MapStatics.startZoom, animated: false)
            focusUserLocation()
            setLocation(loc)
            directionDidChange(direction: LocationService.shared.direction)
        }
    }
    
    func setLocation(_ location: CLLocation){
        userLocationView.updateLocation(location: MapCalculator.planetPointFromCoordinate(coordinate: location.coordinate), offset: contentOffset, scale: scale)
    }
    
    func setDirection(_ direction: CLLocationDirection) {
        userLocationView.updateDirection(direction: direction)
    }
    
    func addAnnotation(annotation: MapAnnotation){
        annotationView.addAnnotationControl(annotation: annotation)
        MapAnnotationCache.instance.save()
        annotationView.updatePosition(offset: contentOffset, scale: scale)
    }
    
}

extension MapView : UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        assertCenteredContent(scrollView: scrollView)
        userLocationView.updatePosition(offset: contentOffset, scale: scale)
        annotationView.updatePosition(offset: contentOffset, scale: scale)
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

extension MapView: LocationServiceDelegate{
    
    func authorizationDidChange(authorized: Bool) {
        if authorized && !locationInitialized{
            initLocation()
        }
    }
    
    func locationDidChange(location: CLLocation) {
        if !locationInitialized{
            initLocation()
        }
        else{
            setLocation(location)
        }
        
    }
    
    func directionDidChange(direction: CLLocationDirection) {
        setDirection(direction)
    }
    
}

extension MapView: MapAnnotationViewDelegate{
    
    func showAnnotation(annotation: MapAnnotation) {
        let controller = MapAnnotationViewController()
        controller.modalPresentationStyle = .fullScreen
        self.controller.present(controller, animated: true)
    }
    
    func editAnnotation(annotation: MapAnnotation) {
        let controller = EditAnnotationViewController()
        controller.modalPresentationStyle = .fullScreen
        self.controller.present(controller, animated: true)
    }
    
    func deleteAnnotation(annotation: MapAnnotation) {
        MapAnnotationCache.instance.removeAnnotation(annotation)
        MapAnnotationCache.instance.save()
    }
    
}

extension MapView: MapControlDelegate{
    
    func focusUserLocation() {
        if let location = LocationService.shared.location{
            scrollToCenteredCoordinate(coordinate: location.coordinate)
        }
    }
    
    func addAnnotationAtCross(){
        let coordinate = getCoordinate(screenPoint: CGPoint(x: scrollView.visibleSize.width/2, y: scrollView.visibleSize.height/2))
        let annotation = MapAnnotationCache.instance.addAnnotation(coordinate: coordinate)
        addAnnotation(annotation: annotation)
    }
    
    func addAnnotationAtUserPosition(){
        if let location = LocationService.shared.location{
            let annotation = MapAnnotation(coordinate: location.coordinate)
            addAnnotation(annotation: annotation)
        }
    }
    
    func changeMap(){
        if MapType.current.name == MapType.carto.name{
            MapType.current = .topo
        }
        else{
            MapType.current = .carto
        }
    }
    
    func openInfo() {
        let controller = InfoViewController()
        controller.modalPresentationStyle = .fullScreen
        self.controller.present(controller, animated: true)
    }
    
    func openCamera() {
        let controller = PhotoViewController()
        controller.modalPresentationStyle = .fullScreen
        self.controller.present(controller, animated: true)
    }
    
    func openTour() {
        let controller = TourViewController()
        controller.modalPresentationStyle = .fullScreen
        self.controller.present(controller, animated: true)
    }
    
    func openSearch() {
        let controller = SearchViewController()
        controller.modalPresentationStyle = .fullScreen
        self.controller.present(controller, animated: true)
    }
    
    func openPreferences(){
        let controller = MapPreferencesViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        self.controller.present(controller, animated: true)
    }
    
    
    
}

extension MapView: PreferencesDelegate{
    
    func clearTileCache() {
        MapTileCache.clear()
    }
    
    func removeAnnotations() {
        MapAnnotationCache.instance.annotations.removeAll()
        annotationView.setupAnnotations()
    }
    
}


