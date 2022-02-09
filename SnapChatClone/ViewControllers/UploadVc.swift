//
//  UploadVc.swift
//  SnapChatClone
//
//  Created by Hamit Seyrek on 9.02.2022.
//

import UIKit
import Firebase

class UploadVc: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        uploadImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func selectImage () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func uploadButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("media")
        
        guard let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let uuID = UUID().uuidString
        let imageReferance = mediaFolder.child("\(uuID).jpg")
        imageReferance.putData(data, metadata: nil) { metaData, error in
            if error == nil {
                imageReferance.downloadURL { url, error in
                    if error == nil {
                        let imageUrl = url?.absoluteString
                        
                        let fireStore = Firestore.firestore()
                        let snapDic = ["imageUrl" : imageUrl!, "owner" : UserSingleton.sharedInstance.userName, "data" : FieldValue.serverTimestamp()] as [String : Any]
                        fireStore.collection("snaps").addDocument(data: snapDic) { error in
                            if error == nil {
                                self.tabBarController?.selectedIndex = 0
                                self.uploadImageView.image = UIImage(named: "selectImage.png")
                            }
                        }
                    }
                }
            } else {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
}
