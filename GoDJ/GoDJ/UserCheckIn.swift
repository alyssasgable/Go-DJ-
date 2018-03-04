//
//  UserCheckIn.swift
//  GoDJ
//
//  Created by ALYSSA on 3/3/18.
//  Copyright © 2018 AlyssaGable. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit
import UserNotifications
import SwiftyJSON
import Alamofire

class UserCheckIn: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    let mapView = MKMapView()
    var currentLocation = CLLocation()
    var dj = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = UIColor.black
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 150
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        setupView()
        getDJLocations()
//        addPin(coordinates: (locationManager.location?.coordinate)!, djName: nil)
//        addPin(coordinates: CLLocationCoordinate2D(latitude: 30.4453319, longitude: -84.3189339), djName: "Test")
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    func centerMapOnLocation(_ location: CLLocation?) {
        if let currentLocation = location {
//            locationHasBeenFound = true
            
            let span = MKCoordinateSpanMake(0.050, 0.050)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), span: span)
            mapView.setRegion(region, animated: true)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation

        centerMapOnLocation(userLocation)
        manager.stopUpdatingLocation()

//        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)

//        addPin(coordinates: coordinations)

    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "djName"
        
        let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
        annotationView.isEnabled = true
        annotationView.canShowCallout = true
        
        let djButton = UIButton(type: .detailDisclosure)
        let buttonImage = UIImage(named: "headphones")
        let imageSize:CGSize = CGSize(width: 50, height: 50)
        djButton.imageEdgeInsets = UIEdgeInsetsMake(djButton.frame.size.height/2 - imageSize.height/2, djButton.frame.size.width/2 - imageSize.width/2, djButton.frame.size.height/2 - imageSize.height/2, djButton.frame.size.width/2 - imageSize.width/2)
        djButton.setImage(buttonImage, for: .normal)
        djButton.addTarget(self, action: #selector(request), for: .touchUpInside)
        annotationView.rightCalloutAccessoryView = djButton
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        request(djName: ((view.annotation?.title)!)!)
    }
    
    func addPin(coordinates: CLLocationCoordinate2D, djName: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        if djName != nil {
            annotation.title = djName
            dj = djName!
        }
        mapView.addAnnotation(annotation)
    }
    
    func getDJLocations() {
        let url = URL(string: "https://5wt88x02a2.execute-api.us-east-2.amazonaws.com/prod/addSong/Zach/ALL")
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print("JSON: \(json)")
                
                for location in json {
                    let dj = location["djName"].stringValue
                    
                    let stringLat = location["lat"].stringValue
                    let doubleLat = Double(stringLat)

                    let stringLong = location["lon"].stringValue
                    let doubleLong = Double(stringLong)
                    let location = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                    self.addPin(coordinates: location, djName: dj)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func request(djName: String) {
        let sq = SongQueue(dj: djName)
        sq.canDelete = false
        self.navigationController?.pushViewController(sq, animated: true)
    }

}
