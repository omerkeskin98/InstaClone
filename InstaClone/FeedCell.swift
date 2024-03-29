//
//  FeedCell.swift
//  InstaClone
//
//  Created by Omer Keskin on 7.03.2024.
//

import UIKit
import Firebase
import Foundation
import OneSignalFramework

class FeedCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var imageTableView: UIImageView!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let firestoreDataBase = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            firestoreDataBase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
        
        
        let userEmail = userLabel.text!
        firestoreDataBase.collection("SubscriptionIds").whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, error) in
            if error == nil{
                if snapshot?.isEmpty == false && snapshot != nil{
                    for document in snapshot!.documents{
                        
                        if let subsId = document.get("SubscriptionId") as? String{
                            
                            
                            
                            // push notification

                            let headers = [
                              "accept": "application/json",
                              "Authorization": "Basic YTliNGRhMTgtMzYyOS00ZWNjLThlZTktMGVkNDcwZTc3YjAw",
                              "content-type": "application/json"
                            ]
                            let parameters = [
                              "app_id": "423fd01a-a592-4c13-9553-5045a135d1a2",
                              "name": "Test",
                              "include_subscription_ids": ["\(subsId)"],
                              "contents": ["en": "\(Auth.auth().currentUser!.email!) liked your post!"]
                            ] as [String : Any]

                            do{
                                let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                                let request = NSMutableURLRequest(url: NSURL(string: "https://api.onesignal.com/notifications")! as URL,
                                                                        cachePolicy: .useProtocolCachePolicy,
                                                                    timeoutInterval: 10.0)
                                request.httpMethod = "POST"
                                request.allHTTPHeaderFields = headers
                                request.httpBody = postData as Data
                                
                                let session = URLSession.shared
                                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                                  if (error != nil) {
                                    print(error as Any)
                                  } else {
                                    let httpResponse = response as? HTTPURLResponse
                                    print(httpResponse ?? "http error")
                                  }
                                })

                                dataTask.resume()
                            }catch{
                                print("json error")
                            }
                        }
                    }
                }
            }
        }
        







        
    }
    
}
