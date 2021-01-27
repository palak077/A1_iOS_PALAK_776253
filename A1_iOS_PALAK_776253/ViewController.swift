//
//  ViewController.swift
//  A1_iOS_PALAK_776253
//
//  Created by Macbook on 2021-01-25.
//

import UIKit
import MapKit

class ViewController: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var directionbtn: UIButton!

    var locationManager = CLLocationManager()
    var arrayCoordinates = [CLLocationCoordinate2D]()
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        map.showsUserLocation = true
        map.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        addDoubleTap()
        directionbtn.isHidden = true
    }
    func addDoubleTap()
    {
        let doubleTap = UITapGestureRecognizer(target: self , action: #selector(dropPin))
        doubleTap.numberOfTapsRequired = 2
        map.addGestureRecognizer(doubleTap)
    }
    @objc func dropPin(sender: UITapGestureRecognizer)
    {
        if arrayCoordinates.count == 3
        {
            removePin()
            arrayCoordinates.removeAll()
            print("array cleared")
            map.removeOverlays(map.overlays)
            print("polygon cleared")
        }
        let touchpoint = sender.location(in: map)
        let coordinate = map.convert(touchpoint, toCoordinateFrom: map)
        
        self.arrayCoordinates.append(coordinate)
                
        if arrayCoordinates.count == 1
            {
            let annotation = MKPointAnnotation()
            annotation.title = "A"
            annotation.coordinate = arrayCoordinates[0]
            map.addAnnotation(annotation)
            }
        else if arrayCoordinates.count == 2
            {
            let annotation = MKPointAnnotation()
            annotation.title = "B"
            annotation.coordinate = arrayCoordinates[1]
            map.addAnnotation(annotation)
            }
        else if arrayCoordinates.count == 3
            {
            let annotation = MKPointAnnotation()
            annotation.title = "C"
            annotation.coordinate = arrayCoordinates[2]
            map.addAnnotation(annotation)
            print(arrayCoordinates)
            addPolygon()
            print("polygon added")
            
//            let Point1 = arrayCoordinates[0]
//            let Point2 = arrayCoordinates[1]
//            let Point3 = arrayCoordinates[2]
            
//            var coordinateInput:[CLLocationCoordinate2D]=[Point1,Point2,Point3]
//            let polygon = MKPolygon(coordinates: &coordinateInput, count: coordinateInput.count)
//            map.addOverlay(polygon)
//            directionbtn.isHidden = false
            
            
//            let sourceLocation = arrayCoordinates[0]
//            let destinationLocation = arrayCoordinates[1]
//            let middleLocation = arrayCoordinates[2]

//            createPath(sourceLocation: sourceLocation, destinationLocation: destinationLocation)
//            createPath(sourceLocation: destinationLocation, destinationLocation: middleLocation)
//            createPath(sourceLocation: middleLocation, destinationLocation: sourceLocation)
                
        }
    }
    @IBAction func drawRoute(_ sender: Any)
    {
                    let sourceLocation = arrayCoordinates[0]
                    let destinationLocation = arrayCoordinates[1]
                    let middleLocation = arrayCoordinates[2]

                    createPath(sourceLocation: sourceLocation, destinationLocation: destinationLocation)
                    createPath(sourceLocation: destinationLocation, destinationLocation: middleLocation)
                    createPath(sourceLocation: middleLocation, destinationLocation: sourceLocation)
    }
    
    //MARK: - remove pin from the map
    func removePin()
    {
        for annotation in map.annotations
        {
            map.removeAnnotation(annotation)
        }
    }
    func createPath(sourceLocation : CLLocationCoordinate2D, destinationLocation : CLLocationCoordinate2D)
    {
            map.removeOverlays(map.overlays)
            print("Polygon removed")
            print("Route is created")
            let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
            let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
            let destinationItem = MKMapItem(placemark: destinationPlaceMark)

            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationItem
            directionRequest.transportType = .automobile
            
            let direction = MKDirections(request: directionRequest)
            
            direction.calculate { (response, error) in
                guard let response = response else {
                    if let error = error {
                        print("ERROR FOUND : \(error.localizedDescription)")
                    }
                    return
                }
                
                let route = response.routes[0]
                self.map.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                let rect = route.polyline.boundingMapRect
               self.map.setRegion(MKCoordinateRegion(rect), animated: true)
                
            }
        }
    
    //MARK: - polygon  meyhod
    func addPolygon()
    {
                   let Point1 = arrayCoordinates[0]
                   let Point2 = arrayCoordinates[1]
                   let Point3 = arrayCoordinates[2]
        
//        let startingPoint1 = CLLocationCoordinate2D(latitude:43.6532,longitude: -79.3832)
//        //let startingPoint1 = arrayCoordinates[0]
//        let startingPoint2 = CLLocationCoordinate2D(latitude: 43.8561, longitude: -79.3370)
//        let endingPoint1 = CLLocationCoordinate2D(latitude: 43.8563, longitude: -79.5085)

        var coordinateInput:[CLLocationCoordinate2D]=[Point1,Point2,Point3]
        let polygon = MKPolygon(coordinates: &coordinateInput, count: coordinateInput.count)
        map.addOverlay(polygon)
        directionbtn.isHidden = false
    }
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {
            let userLocation = locations[0]
    
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
    
            displayLocation(latitude: latitude, longitude: longitude, title: "You are here", subtitle: "")
        }
        
       // MARK: - display user location method
         
         func displayLocation (latitude: CLLocationDegrees,
                               longitude: CLLocationDegrees,
                               title: String,
                               subtitle:String)
         {
             let latDelta: CLLocationDegrees = 0.05
             let lngDelta: CLLocationDegrees = 0.05
    
             let span = MKCoordinateSpan (latitudeDelta: latDelta, longitudeDelta: lngDelta)
             let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
             let region = MKCoordinateRegion(center: location, span: span)
             map.setRegion(region, animated: true)
    
             let annotation = MKPointAnnotation()
             annotation.title = title
             annotation.subtitle = subtitle
             annotation.coordinate = location
             map.addAnnotation(annotation)
         }
}
extension ViewController : MKMapViewDelegate
    {
        //MARK: - view for annotation method
    
//        func mapView(_ mapView: MKMapView, viewFor annotaion : MKAnnotation) -> MKAnnotationView?
//        {
//            if annotaion is MKUserLocation
//            {
//                return nil
//            }
//            let pinAnnotation = MKPinAnnotationView(annotation: annotaion, reuseIdentifier: "droppablePin")
//           pinAnnotation.animatesDrop = true
//            pinAnnotation.pinTintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            
//            let pinAnnotation = map.dequeueReusableAnnotationView(withIdentifier: "droppablePin") ?? MKPinAnnotationView()
//           // pinAnnotation.image = UIImage(named: "ic_place_2x")
//            pinAnnotation.canShowCallout = true
//            pinAnnotation.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            //return pinAnnotation

       // }
    
        //MARK: - callout accessory control tapped
    
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
        {
            let alertController = UIAlertController(title: "Your Location" , message: "Nice Place to visit", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    
        //MARK: - render for overlay func
    
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKCircle
            {
                let rendrer = MKCircleRenderer(overlay: overlay)
                rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
                rendrer.strokeColor = UIColor.green
                rendrer.lineWidth = 2
                return rendrer
            }
            else if overlay is MKPolyline
            {
                let rendrer = MKPolylineRenderer(overlay: overlay)
                rendrer.strokeColor = UIColor.blue
                rendrer.lineWidth = 3
                return rendrer
            }
            else if overlay is MKPolygon
            {
                let rendrer = MKPolygonRenderer(overlay: overlay)
                rendrer.fillColor = UIColor.red.withAlphaComponent(0.5)
                rendrer.strokeColor = UIColor.green
                rendrer.lineWidth = 4
                return rendrer
            }
            return MKOverlayRenderer()
        }
}
