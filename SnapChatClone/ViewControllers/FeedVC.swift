//
//  FeedVC.swift
//  SnapChatClone
//
//  Created by Hamit Seyrek on 9.02.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    let fireStoreDataBase = Firestore.firestore()
    var snapArray = [Snap]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        getUserInfo()
        getSnapsFromFirestore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableCell
        cell.userNameLabel.text = snapArray[indexPath.row].username
        cell.cellImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
    // MARK: - Special Functions
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
                self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error in here!!")
            }
        }
    }
    
    func getSnapsFromFirestore() {
        fireStoreDataBase.collection("snaps").order(by: "data", descending: true).addSnapshotListener { snapShots, error in
            if error != nil {
                self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error in here!!")
            } else {
                if snapShots?.isEmpty == false && snapShots != nil {
                    self.snapArray.removeAll()
                    for document in snapShots!.documents {
                        let documentID = document.documentID
                        if let username = document.get("owner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("data") as? Timestamp {
                                    if let diffTime = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if diffTime > 24 {
                                            self.fireStoreDataBase.collection("snaps").document(documentID).delete()
                                        }
                                    }
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                                    self.snapArray.append(snap)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func makeAlert(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
    
}
