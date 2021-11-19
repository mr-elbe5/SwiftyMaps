/*
 OSM-Maps
 Project for displaying a map like OSM without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol TileLayerDelegate{
    func zoomDidChange(zoom : Int)
}

class TileLayerView: UIView {
    
    var screenScale : CGFloat = 1.0
    
    // this is the factor from planet zoom: drawRect*scale=tileSize,
    // same as MapCalculator.zoomScaleFromPlanet(to: zoom)
    private var _scaleToPlanet : CGFloat = 0.0
    var scaleToPlanet : CGFloat{
        get{
            _scaleToPlanet
        }
        set{
            if _scaleToPlanet  != newValue{
                _scaleToPlanet = newValue
                let newZoom = MapStatics.maxZoom - MapCalculator.zoomLevelFromScale(scale: _scaleToPlanet)
                if zoom != newZoom{
                    zoom = newZoom
                    DispatchQueue.main.async {
                        self.delegate?.zoomDidChange(zoom: self.zoom)
                    }
                }
            }
        }
    }
    var zoom : Int = 0
    
    var delegate : TileLayerDelegate? = nil
    
    override init(frame: CGRect){
        super.init(frame: frame)
        screenScale = tileLayer.contentsScale
        tileLayer.tileSize = CGSize(width: MapStatics.tileSize.width*screenScale, height: MapStatics.tileSize.height*screenScale)
        tileLayer.levelsOfDetail = MapStatics.maxZoom
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
        var x = Int(round(rect.minX / scaleToPlanet / MapStatics.tileSize.width))
        let y = Int(round(rect.minY / scaleToPlanet / MapStatics.tileSize.height))
        let currentMaxTiles = Int(MapCalculator.zoomScale(at: zoom))
        // for infinite scroll
        while x >= currentMaxTiles{
            x -= currentMaxTiles
        }
        let tile = MapTileCache.getTile(zoom: zoom, x: x, y: y)
        if let image = tile.image{
            image.draw(in: rect)
            return
        }
        MapStatics.mapGearImage?.draw(in: rect.scaleCenteredBy(0.25))
        MapTileLoader.loadTileImage(tile: tile){ data in
            if MapTileCache.saveTile(tile: tile, data: data){
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



