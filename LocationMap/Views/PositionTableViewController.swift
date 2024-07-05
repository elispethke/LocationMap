//
//  PositionTableViewController.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import UIKit

class PositionTableViewController: UITableViewController {
    
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingIndicator: UIView!
    
    var map = [LearnerLocation]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLearnerLocations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func updateData(_ sender: Any) {
        updateUIAfter(true)
        fetchLearnerLocations()
    }
    
    private func fetchLearnerLocations() {
        TheMapAPIClient.performGETRequest(url: TheMapAPIClient.Endpoints.fetchLearnerLocations.url, responseType: LearnerLocationsResponse.self) { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showFailure(message: error.localizedDescription)
            } else if let response = response {
                self.map = response.results 
                self.upTableView()
            } else {
                
                self.showFailure(message: "Unknown error")
            }
            
            self.updateUIAfter(false)
        }
    }

    
    private func setupUI() {
        loadingIndicator.isHidden = true
    }
    
    private func updateUIAfter(_ refreshing: Bool) {
        if refreshing {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        loadingIndicator.isHidden = !refreshing
    }
    
    private func upTableView() {
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return map.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let location = map[indexPath.row]
        
        cell.textLabel?.text = "\(location.giventName ?? "") \(location.familyName ?? "")"
        cell.detailTextLabel?.text = location.urlMedia
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = map[indexPath.row]
        
        guard let mediaURLString = selectedLocation.urlMedia, let url = URL(string: mediaURLString) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
