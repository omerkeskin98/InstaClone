//
//  ViewController.swift
//  InstaClone
//
//  Created by Omer Keskin on 6.03.2024.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signUpClicked(_ sender: Any) {
   
        if emailText.text != "" || passwordText.text != ""{
           Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil{
                    self.alertFunc(alertTitle: "Error", alertMessage: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
               }
            }
        }
        else{
            alertFunc(alertTitle: "Sign Up Error", alertMessage: "Please enter your email and password")
        }
    }
    
                                   
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" || passwordText.text != ""{
           Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil{
                    self.alertFunc(alertTitle: "Error", alertMessage: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
               }
            }
        }
        else{
            alertFunc(alertTitle: "Sign In Error", alertMessage: "Please enter correct email and password")
        }
    }
    
    
    @objc func alertFunc(alertTitle: String, alertMessage: String){
        let warning = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        warning.addAction(okButton)
        self.present(warning, animated: true, completion: nil)
        
    }
}

