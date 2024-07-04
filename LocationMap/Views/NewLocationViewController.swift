//
//  NewLocationViewController.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import UIKit
import MapKit

class NewLocationViewController: UIViewController, MKMapViewDelegate {
    
    var location: String?
    var coordinate: CLLocationCoordinate2D?
    var link: String?
    
    var locationData: LocationData?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupMapView()
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finish(_ sender: Any) {
        postStudentLocation()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancel))
        navigationItem.title = "New Location"
    }
    
    private func setupMapView() {
        guard let locationData = locationData else {
            displayError(message: "No location data found.")
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationData.coordinate
        annotation.title = "\(Auth.firstName) \(Auth.lastName)"
        annotation.subtitle = locationData.link
        
        let region = MKCoordinateRegion(center: locationData.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
        
        mapView.delegate = self
    }
    
    private func postStudentLocation() {
        guard let locationData = locationData else {
            displayError(message: "No location data found.")
            return
        }
        
        APITheMapClient.postStudentLocation(mapString: locationData.location, mediaURL: locationData.link, latitude: locationData.coordinate.latitude, longitude: locationData.coordinate.longitude) { [weak self] (success, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if success {
                    print("Posted Student Location Successfully")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Posting Student Location Failed!")
                    self.displayError(message: error?.localizedDescription ?? "Unknown error")
                }
            }
        }
    }

    
    private func displayError(message: String) {
        let alertVC = UIAlertController(title: "Submission Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension NewLocationViewController{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.image = UIImage(named: "custom_pin")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard control == view.rightCalloutAccessoryView, let subtitle = view.annotation?.subtitle, let urlString = subtitle, let url = URL(string: urlString) else { return }
        
        UIApplication.shared.open(url)
    }
    
}
