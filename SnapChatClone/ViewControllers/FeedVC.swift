//
//  FeedVC.swift
//  SnapChatClone
//
//  Created by Hamit Seyrek on 9.02.2022.
//

import UIKit
import Firebase

class FeedVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    let fireStoreDataBase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getUserInfo()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Navigation
    func getUserInfo () {
        fireStoreDataBase.collection("userInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapShots, error in
            if error == nil {
                if snapShots?.isEmpty == false && snapShots != nil {
                    for document in snapShots!.documents {
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedInstance.userName = username
                            UserSingleton.sharedInstance.email = Auth.auth().currentUser?.email ?? ""
                            
                        }
                    }
                }
            } else {
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription ?? "Error in here!!", preferredStyle: UIAlertController.Style.alert)
                let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
