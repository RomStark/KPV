//
//  MapViewController.swift
//  Charity
//
//  Created by Al Stark on 30.11.2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    private let map = MKMapView()
    private var locationManager = CLLocationManager()

    private var selfCoordinate = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        setupMap()
        setupLocationManager()
    }
    
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        

        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            map.setRegion(viewRegion, animated: false)
        }
        
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    
    private func setupMap() {
        view.addSubview(map)
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        map.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        map.showsUserLocation = true
        
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        map.setRegion(viewRegion, animated: false)
        for charity in MainTableViewController.charities {
            if charity.coordinate.longitude == 0 {
                continue
            }
            map.addAnnotation(charity)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is CharityClass else { return nil}
        var viewMarker: MKMarkerAnnotationView
        let idView = "marker"
        if let view = map.dequeueReusableAnnotationView(withIdentifier: idView) as? MKMarkerAnnotationView {
            view.annotation = annotation
            viewMarker = view
        } else {
            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: idView)
            viewMarker.canShowCallout = true
            viewMarker.calloutOffset = CGPoint(x: 0, y: 5)
            viewMarker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return viewMarker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        map.removeOverlays(map.overlays)
        
        let charity = view.annotation as! CharityClass
        let startPoint = MKPlacemark(coordinate: coordinate)
        let endPoint = MKPlacemark(coordinate: charity.coordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        
        direction.calculate { [weak self] response, error in
            
            guard let self else { return }
            
            guard let response = response else { return }
            
            for route in response.routes {
                self.map.addOverlay(route.polyline)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4
        return renderer
    }
}

//extension MapViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let coordinate: CLLocationCoordinate2D = manager.location?.coordinate else {
//            return
//        }
////        selfCoordinate.latitude = coordinate.latitude
////        selfCoordinate.longitude = coordinate.longitude
//    }
//}
