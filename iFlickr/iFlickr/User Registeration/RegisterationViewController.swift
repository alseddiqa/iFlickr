//
//  RegisterationViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/3/20.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth

class RegisterationViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    //var delegate: SignUpDelegate!
    var ref: DatabaseReference!

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //self.delegate.updateView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUpTextFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setUpTextFields() {
        
        nameField.layer.cornerRadius = 15.0
        nameField.layer.borderWidth = 2.0
        nameField.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        nameField.layer.masksToBounds = true
        
        emailTextField.layer.cornerRadius = 15.0
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 15.0
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        passwordTextField.layer.masksToBounds = true
        
        signUpButton.layer.cornerRadius = 15.0
        signUpButton.layer.borderWidth = 2.0
        signUpButton.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        signUpButton.layer.masksToBounds = true
    }

    @IBAction func handleSignUp(_ sender: UIButton) {
        
        if validateTextFields() == false {
            return
        }
        
        ref = Database.database().reference()
        let name = nameField.text
        let email =  emailTextField.text
        let password =  passwordTextField.text
        
        let userInformation = ["name": name, "emailAddress": email]
        Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
            guard let user = authResult?.user, error == nil else {
                print("Error: \(error?.localizedDescription)")
                return
            }
            let id = user.uid
            self.ref.child("Users").child("\(id)").setValue(userInformation)
            //print("registered")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func validateTextFields() -> Bool{
        
        let name = nameField.text!
        let email = emailTextField.text!
        let pass = passwordTextField.text!

        
        if name.count == 0 {
            nameField.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            nameField.layer.borderWidth = 1.0
            let title = NSLocalizedString("Name Field is empty!", comment: "")
            let message = NSLocalizedString("Am I a joke to you?", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let respone = NSLocalizedString("Sorry, I'll fill them now", comment: "")
            alert.addAction(UIAlertAction(title: respone, style: .destructive, handler: nil))
            self.present(alert, animated: true)
            
            return false
        }
        else if email.count == 0 {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
