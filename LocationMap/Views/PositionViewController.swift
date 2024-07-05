//
//  PositionViewController.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import UIKit
import MapKit

class PositionViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var locations = [LearnerLocation]() {
        didSet {
            updateMapAnnotations()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLearnerLocations()
    }
    
    @IBAction func reloadContent(_ sender: Any) {
        fetchLearnerLocations()
    }
    
    private func fetchLearnerLocations() {
        updateUIAfter(true)
        TheMapAPIClient.retrieveLearnerLocations { [weak self] locations, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showFailure(message: error.localizedDescription)
            } else {
                self.locations = locations
            }
            
            self.updateUIAfter(false)
        }
    }
    
    
    private func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            let lat = location.lat
            let long = location.long
            
            
            guard lat != 0.0 && long != 0.0 else {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let title = "\(location.giventName ?? "") \(location.familyName ?? "")"
            let subtitle = location.urlMedia ?? ""
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = title
            annotation.subtitle = subtitle
            
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    private func updateUIAfter(_ refreshing: Bool) {
        if refreshing {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Failed to Fetch Locations", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension PositionViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "location"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.displayPriority = .required
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let urlString = view.annotation?.subtitle, let url = URL(string: urlString ?? "") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}



