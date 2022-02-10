//
//  SettingsVC.swift
//  SnapChatClone
//
//  Created by Hamit Seyrek on 9.02.2022.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVCS", sender: nil)
        } catch {
            let alert = UIAlertController(title: "Error!", message: "User can not sign out!!!", preferredStyle: UIAlertController.Style.alert)
            let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(button)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
