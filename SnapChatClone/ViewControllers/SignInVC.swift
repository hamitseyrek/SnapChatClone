//
//  ViewController.swift
//  SnapChatClone
//
//  Created by Hamit Seyrek on 8.02.2022.
//

import UIKit
import Firebase
import simd

class SignInVC: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func SignInButtonClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { result, error in
                if error == nil {
                    self.performSegue(withIdentifier: "toFeedVCS", sender: nil)
                } else {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Use couldnt resigter")
                }
            }
        } else {
            makeAlert(title: "Error!!", message: "There ise a error in here. Username/email/passwor !!")
        }
    }
    
    @IBAction func SignUpButtonClicked(_ sender: Any) {
        if emailText.text != "" && userNameText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { result, error in
                if error == nil {
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["email" : self.emailText.text!, "username" : self.userNameText.text!]
                    fireStore.collection("userInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                            self.makeAlert(title: "Error!!", message: error?.localizedDescription ?? "Error in firestore store")
                        }
                    }
                    self.performSegue(withIdentifier: "toFeedVCS", sender: nil)
                } else {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Use couldnt resigter")
                }
            }
        } else {
            makeAlert(title: "Error!!", message: "There ise a error in here.")
        }
    }
    
    //MARK: - Special Functions
    func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
}

