//
//  SettingsViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/3/20.
//

import UIKit
import FirebaseAuth

/// Settings view contrller, could add more option later, but now it's just for loggin out
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Perform logout from the app when the user taps on logout
    /// - Parameter sender: log out button
    @IBAction func handleLogOut(_ sender: UIButton) {
        
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }

}
