/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit

class MapModel
{
    
    var name: String = "New"

    var regionRadius: Double = 1000
    var mapWidth: Double = 1000
    var mapHeight: Double = 1000
    
    
    var spanLatitudeDelta: CLLocationDegrees = 0.1
    var spanLongitudeDelta: CLLocationDegrees = 0.1
    
    
    
    var boundary: [CLLocationCoordinate2D] = []
    
    
    var midCoordinate = CLLocationCoordinate2D()
    var overlayTopLeftCoordinate = CLLocationCoordinate2D()
    var overlayTopRightCoordinate = CLLocationCoordinate2D()
    var overlayBottomLeftCoordinate = CLLocationCoordinate2D()
    
    var overlayBottomRightCoordinate: CLLocationCoordinate2D
    {
        get
        {
            return CLLocationCoordinate2DMake(overlayBottomLeftCoordinate.latitude,
                                        overlayTopRightCoordinate.longitude)
        }
    }
  
    var overlayBoundingMapRect: MKMapRect
    {
        get
        {
            let topLeft = MKMapPointForCoordinate(overlayTopLeftCoordinate);
            let topRight = MKMapPointForCoordinate(overlayTopRightCoordinate);
            let bottomLeft = MKMapPointForCoordinate(overlayBottomLeftCoordinate);
      
            return MKMapRectMake(
                topLeft.x,
                topLeft.y,
                fabs(topLeft.x - topRight.x),
                fabs(topLeft.y - bottomLeft.y))
        }
    }
  
    init()
    {
        
    }
    
    
    init(locationName: String, midCoord: CLLocationCoordinate2D, overlayTopLeftCoord: CLLocationCoordinate2D, overlayTopRightCoord: CLLocationCoordinate2D, overlayBottomLeftCoord: CLLocationCoordinate2D, regionRadius: Double)
    {
        self.name = locationName
        self.midCoordinate = midCoord
        self.overlayTopLeftCoordinate = overlayTopLeftCoord
        self.overlayTopRightCoordinate = overlayTopRightCoord
        self.overlayBottomLeftCoordinate = overlayBottomLeftCoord
        self.regionRadius = regionRadius
    }
    
    
    init(locationName: String, midCoord: String, overlayTopLeftCoord: String, overlayTopRightCoord: String, overlayBottomLeftCoord: String)
    {
        //guard let properties = MapModel.plist(filename) as? [String : Any],
        //    let boundaryPoints = properties["boundary"] as? [String] else { return }
        
        midCoordinate = MapModel.parseCoord(location: midCoord)
        overlayTopLeftCoordinate = MapModel.parseCoord(location: overlayTopLeftCoord)
        overlayTopRightCoordinate = MapModel.parseCoord(location: overlayTopRightCoord)
        overlayBottomLeftCoordinate = MapModel.parseCoord(location: overlayBottomLeftCoord)
        
        //let cgPoints = boundaryPoints.map { CGPointFromString($0) }
        //boundary = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
    }
 
 
    static func plist(_ plist: String) -> Any?
    {
        guard let filePath = Bundle.main.path(forResource: plist, ofType: "plist"),
            let data = FileManager.default.contents(atPath: filePath) else { return nil }
    
        do
        {
            return try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        }
        catch
        {
            return nil
        }
    }
  
    
    static func mapCoordinate(latitude: Double, longitude: Double) -> CLLocationCoordinate2D
    {
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        
        print("latitude:\(lat) longitude:\(long)")
        
        return CLLocationCoordinate2DMake(lat, long)
    }
    
    static func createCoordinate(latitude: String, longitude: String) -> CLLocationCoordinate2D
    {
        let lat = CLLocationDegrees(latitude.toDouble()!)
        let long = CLLocationDegrees(longitude.toDouble()!)
        
        print("latitude:\(lat) longitude:\(long)")
        
        return CLLocationCoordinate2DMake(lat, long)
    }
    
    static func parseCoord(location: String) -> CLLocationCoordinate2D
    {
        if let coord = location as? String
        {
            let point = CGPointFromString(coord)
            return CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
        }
        
        return CLLocationCoordinate2D()
    }
    
    static func parseCoordDict(dict: [String: Any], fieldName: String) -> CLLocationCoordinate2D
    {
        if let coord = dict[fieldName] as? String
        {
            let point = CGPointFromString(coord)
            return CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
        }
    
        return CLLocationCoordinate2D()
    }
 
}
