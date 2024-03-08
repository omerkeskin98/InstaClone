//
//  FeedViewController.swift
//  InstaClone
//
//  Created by Omer Keskin on 6.03.2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var commentArray = [String]()
    var likeArray = [Int]()
    var imageArray = [String]()
    var documentIdArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userLabel.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = commentArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.imageTableView.sd_setImage(with: URL(string: self.imageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    func getDataFromFirestore(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription ?? "Error")
            }
            else{
                
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.commentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageURL") as? String{
                            self.imageArray.append(imageUrl)
                        }
                        
                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }

}
