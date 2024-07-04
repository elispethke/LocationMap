//
//  SignInViewController.swift
//  LocationMap
//
//  Created by Elisangela Pethke on 04.07.24.
//

import UIKit

protocol LoginHandling: AnyObject {
    func login(username: String, password: String)
    func showLoginFailure(message: String)
}

class SignInViewController: UIViewController, LoginHandling {
    
    @IBOutlet weak var usernameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTextFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceholderTexts()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            showLoginFailure(message: "Username or Password cannot be empty.")
            return
        }
        login(username: username, password: password)
    }
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(APITheMapClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    func login(username: String, password: String) {
        APITheMapClient.createSessionId(username: username, password: password) { [weak self] success, error in
            guard let self = self else { return }
            if success {
                print("successfully logged in")
                print(Auth.sessionId)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.showLoginFailure(message: error?.localizedDescription ?? "Unknown error occurred.")
                }
            }
        }
    }
    
    func showLoginFailure(message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    private func resetTextFields() {
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    private func setupPlaceholderTexts() {
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
}

