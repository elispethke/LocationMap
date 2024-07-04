//
//  LocationEntryViewController.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//



import UIKit
import MapKit

struct LocationData {
    var location: String
    var link: String
    var coordinate: CLLocationCoordinate2D
}

class LocationEntryViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationData: LocationData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        fetchUserData()
    }
    
    @IBAction func findLocation(_ sender: Any) {
        guard let address = locationTextField.text, !address.isEmpty else {
            displayError(message: "Location field cannot be empty.")
            return
        }
        
        guard let link = linkTextField.text, !link.isEmpty else {
            displayError(message: "Link field cannot be empty.")
            return
        }
        
        refreshUI(isRefreshing: true)
        getCoordinate(addressString: address) { [weak self] coordinate, error in
            guard let self = self else { return }
            self.refreshUI(isRefreshing: false)
            
            if let error = error {
                self.displayError(message: error.localizedDescription)
            } else {
                let locationData = LocationData(location: address, link: link, coordinate: coordinate)
                self.locationData = locationData
                self.performSegue(withIdentifier: "addLocation", sender: self)
            }
        }
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Add Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancel))
    }
    
    private func fetchUserData() {
        print("Fetching user data...")
    }
    
    private func getCoordinate(addressString: String, completionHandler: @escaping (CLLocationCoordinate2D, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if let error = error {
                completionHandler(kCLLocationCoordinate2DInvalid, error)
                return
            }
            guard let placemark = placemarks?.first else {
                completionHandler(kCLLocationCoordinate2DInvalid, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No placemark found."]))
                return
            }
            let location = placemark.location!
            DispatchQueue.main.async {
                completionHandler(location.coordinate, nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "addLocation", let addLocationVC = segue.destination as? LocationEntryViewController else { return }
        
        addLocationVC.locationData = locationData
    }
    
    private func displayError(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true)
    }
    
    private func refreshUI(isRefreshing: Bool) {
        if isRefreshing {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
}
