//
//  LoginViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/3/20.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //Declaring VC outlet
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginRegisterSegment: UISegmentedControl!
    @IBOutlet var signInButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUpTextFields()
        loginRegisterSegment.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    /// styling out textfields in login view controller
    func setUpTextFields() {
        loginRegisterSegment.selectedSegmentIndex = 0
        
        emailTextField.layer.cornerRadius = 15.0
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 15.0
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        passwordTextField.layer.masksToBounds = true
        
        signInButton.layer.cornerRadius = 15.0
        signInButton.layer.borderWidth = 2.0
        signInButton.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        signInButton.layer.masksToBounds = true
    }
    
    /// A helper function execute login check with server for the entered
    /// - Parameter sender: login button
    @IBAction func handleLogin(_ sender: UIButton) {
        
        if validateTextFields() == false {
            return
        }
        let email = emailTextField.text
        let password = passwordTextField.text
        
        
        Auth.auth().signIn(withEmail: email!, password: password!) {[weak self] authResult, error in
            guard let strongSelf = self else {return}
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }
        
        
    }
    
    /// A helper function that checks if any of the fields is empy
    /// - Returns: true if all filled
    func validateTextFields() -> Bool{
        
        let email = emailTextField.text!
        let pass = passwordTextField.text!

        if email.count == 0 {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            emailTextField.layer.borderWidth = 1.0
            let title = NSLocalizedString("Email Field is empty!", comment: "")
            let message = NSLocalizedString("Am I a joke to you?", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let respone = NSLocalizedString("Sorry, I'll fill them now", comment: "")
            alert.addAction(UIAlertAction(title: respone, style: .destructive, handler: nil))
            self.present(alert, animated: true)
            
            return false
        }
        else if pass.count == 0 {
            passwordTextField.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            passwordTextField.layer.borderWidth = 1.0
            let title = NSLocalizedString("Password Field is empty!", comment: "")
            let message = NSLocalizedString("Am I a joke to you?", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let respone = NSLocalizedString("Sorry, I'll fill them now", comment: "")
            alert.addAction(UIAlertAction(title: respone, style: .destructive, handler: nil))
            self.present(alert, animated: true)
            
            return false
        }
        
        return true
    }
    
    /// A function that pops register VC as a modal to the user to register
    /// - Parameter sender: segment controller
    @IBAction func handleSegmentControllerChange(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "RegisterController") as! RegisterationViewController
            
            destVC.modalPresentationStyle = UIModalPresentationStyle.popover
            destVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            destVC.delegate = self
            self.present(destVC, animated: true, completion: nil)
        }
    }
    
}

extension UISegmentedControl {
    
    func setTitleColor(_ color: UIColor, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: state)
    }
    
    func setTitleFont(_ font: UIFont, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.font] = font
        self.setTitleTextAttributes(attributes, for: state)
    }
    
}

extension LoginViewController: SignUpDelegate {
    func updateView() {
        setUpTextFields()
    }
}
