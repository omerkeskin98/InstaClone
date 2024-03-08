//
//  UploadViewController.swift
//  InstaClone
//
//  Created by Omer Keskin on 6.03.2024.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageView.isUserInteractionEnabled = true
        let selectImageGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageFromLibrary))
        imageView.addGestureRecognizer(selectImageGesture)
        uploadButton.isEnabled = false
        
    }
    
    @objc func alertFunc(alertTitle: String, alertMessage: String){
        let warning = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        warning.addAction(okButton)
        self.present(warning, animated: true, completion: nil)
        
    }
    
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.1){
            
            let uuid = UUID().uuidString
            let imageRef = mediaFolder.child("\(uuid).jpg")
            imageRef.putData(data, metadata: nil) { (matadata, error) in
                if error != nil{
                    self.alertFunc(alertTitle: "Error", alertMessage: error?.localizedDescription ?? "Error")
                }
                else{
                    
                    imageRef.downloadURL { (url, error) in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            
                            
                            // DATABASE
                            
                            let firestoreDB = Firestore.firestore()
                            var firestoreRef : DocumentReference? = nil
                            let firestorePost = ["imageURL" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            firestoreRef = firestoreDB.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil{
                                    self.alertFunc(alertTitle: "Error", alertMessage: error?.localizedDescription ?? "Error")
                                }
                                else{
                                    
                                    self.alertFunc(alertTitle: "Uploaded!", alertMessage: "Upload successful")
                                    self.imageView.image = UIImage(named: "upload icon")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                        }
                    }
                }
            }
        }
            
    
    }
    
    
    @objc func selectImageFromLibrary(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        uploadButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)

    }
}
