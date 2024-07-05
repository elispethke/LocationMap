//
//  NewLocationViewController.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import UIKit
import MapKit

class NewLocationViewController: UIViewController, MKMapViewDelegate {
    
    var place: String?
    var coordinate: CLLocationCoordinate2D?
    var customUrl: String?
    
    var locationData: LocationData?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureMapView()
    }
    
    @objc func cancel() {
        dismiss(animated: true) {
            
        }
    }
    
    @IBAction func end(_ sender: Any) {
        submitLerneLocation()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancel))
        navigationItem.title = "New Location"
    }
    
    private func configureMapView() {
        guard let locationData = locationData else {
            showSubmissionFailedAlert(message: "No location data found.")
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationData.coordinate
        annotation.title = "\(UserSession.givenName) \(UserSession.familyName)"
        annotation.subtitle = locationData.customUrl
        
        let region = MKCoordinateRegion(center: locationData.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
        
        mapView.delegate = self
    }
    
    private func submitLerneLocation() {
        guard let locationData = locationData else {
            showSubmissionFailedAlert(message: "No location data found.")
            return
        }
        
        TheMapAPIClient.submitLearnerLocation(locationString: locationData.place, urlMedia: locationData.customUrl, lat: locationData.coordinate.latitude, lon: locationData.coordinate.longitude) { success, error in
            DispatchQueue.main.async { [weak self] in
                if success {
                    print("Posted Student Location Successfully")
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    print("Posting Student Location Failed!")
                    self?.showSubmissionFailedAlert(message: error?.localizedDescription ?? "Unknown error")
                }
            }
        }
    }
    
    
    func showSubmissionFailedAlert(message: String) {
        let alertVC = UIAlertController(title: "Submission Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if presentedViewController == nil {
            present(alertVC, animated: true, completion: nil)
        }
    }

}

extension NewLocationViewController{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let reuseIdentifier = "customPinAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.pinTintColor = .red
            annotationView?.animatesDrop = true
        } else {
            annotationView?.annotation = annotation
        }

        // Additional configuration of the Callout Accessory View
        let detailButton = UIButton(type: .detailDisclosure)
        detailButton.addTarget(self, action: #selector(annotationDetailButtonTapped), for: .touchUpInside)
        annotationView?.rightCalloutAccessoryView = detailButton

        return annotationView
    }

    @objc private func annotationDetailButtonTapped() {
        // Implementation of the action when the details button is tapped
        print("Detalhes da anotação foram tocados.")
    }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard control == view.rightCalloutAccessoryView, let subtitle = view.annotation?.subtitle, let urlString = subtitle, let url = URL(string: urlString) else { return }
        
        UIApplication.shared.open(url)
    }
    
}
