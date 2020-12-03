//
//  LoginViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/3/20.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
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
        // Do any additional setup after loading the view.
    }
    
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
    
    @IBAction func handleLogin(_ sender: UIButton) {
        
        validateFields()
        let email = emailTextField.text
        let password = passwordTextField.text
        
        
        Auth.auth().signIn(withEmail: email!, password: password!) {[weak self] authResult, error in
            guard let strongSelf = self else {return}
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }
        
        
    }
    
    func validateFields() {
        print("Validated")
    }
    
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
