/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

class TileLayerView: UIView {
    
    var screenScale : CGFloat = 1.0
    
    // this is the factor from planet zoom: drawRect*scale=tileSize,
    // same as MapController.zoomScaleFromPlanet(to: zoom)
    private var _scaleToPlanet : CGFloat = 0.0
    var scaleToPlanet : CGFloat{
        get{
            _scaleToPlanet
        }
        set{
            if _scaleToPlanet  != newValue{
                _scaleToPlanet = newValue
                zoom = MapController.maxZoom - MapController.zoomLevelFromScale(scale: _scaleToPlanet)
            }
        }
    }
    var zoom : Int = 0
    
    override init(frame: CGRect){
        super.init(frame: frame)
        screenScale = tileLayer.contentsScale
        tileLayer.tileSize = CGSize(width: MapController.tileSize.width*screenScale, height: MapController.tileSize.height*screenScale)
        tileLayer.levelsOfDetail = MapController.maxZoom
        tileLayer.levelsOfDetailBias = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return CATiledLayer.self
    }
    
    var tileLayer: CATiledLayer {
        return self.layer as! CATiledLayer
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        scaleToPlanet = 1.0/ctx.ctm.a*screenScale
        drawTile(rect: rect)
    }
    
    func drawRect(ctx: CGContext, rect: CGRect, color: UIColor){
        ctx.setStrokeColor(color.cgColor)
        ctx.setLineWidth(2.0/ctx.ctm.a)
        ctx.stroke(rect)
    }
    
    // rect is in contentSize = planetSize
    func drawTile(rect: CGRect){
        var x = Int(round(rect.minX / scaleToPlanet / MapController.tileSize.width))
        let y = Int(round(rect.minY / scaleToPlanet / MapController.tileSize.height))
        let currentMaxTiles = Int(MapController.zoomScale(at: zoom))
        // for infinite scroll
        while x >= currentMaxTiles{
            x -= currentMaxTiles
        }
        let tile = MapTileFiles.getTile(zoom: zoom, x: x, y: y)
        if let image = tile.image{
            image.draw(in: rect)
            return
        }
        MapController.mapGearImage?.draw(in: rect.scaleCenteredBy(0.25))
        MapTileLoader.loadTileImage(tile: tile){ data in
            if MapTileFiles.saveTile(tile: tile, data: data){
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data){
                        tile.image = image
                        self.setNeedsDisplay(rect)
                    }
                }
            }
            else{
                print("error saving tile")
            }
        }
    }
    
}



